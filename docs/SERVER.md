# ShopBandit-Server betreiben

Der Server besteht aus zwei Diensten:

| Dienst | Zweck | Port (intern) |
|---|---|---|
| **PocketBase** (`ghcr.io/crashbandit82/shopbandit-server`) | API, Konten, Daten, Realtime (SSE), Push-Versand | 8090 |
| **ntfy** (`binwiederhier/ntfy`) | UnifiedPush-Verteiler für die Handys | 80 → 8091 |

Das Image enthält das offizielle PocketBase-Release-Binary (Version gepinnt, SHA256 geprüft) plus `pb_migrations/` und `pb_hooks/` aus diesem Repo.

## Docker Compose

```sh
cd server
cp .env.example .env
$EDITOR .env
docker compose up -d
docker compose ps        # beide "healthy"?
```

Admin-Konto (PocketBase-Dashboard unter `https://<domain>/_/`) anlegen:

```sh
docker compose exec pocketbase /pb/pocketbase superuser upsert admin@example.com 'EinLangesPasswort!1' --dir=/pb/pb_data
```

### `.env`

| Variable | Bedeutung |
|---|---|
| `SHOPBANDIT_PUBLIC_URL` | Öffentliche URL der API, für Links in E-Mails |
| `SHOPBANDIT_TRUSTED_PROXY_HEADER` | Header mit der echten Client-IP (für Rate-Limits), meist `X-Real-IP` |
| `SHOPBANDIT_PUSH_HOSTS` | Erlaubte UnifiedPush-Hosts, kommagetrennt (leer = jeder https-Host) |
| `SHOPBANDIT_PUSH_LOCAL` | Optional `https://push.example.com=http://127.0.0.1:8091`: Push für den eigenen ntfy direkt lokal zustellen (wenn der Server seinen öffentlichen Namen nicht erreicht, z. B. ohne Hairpin-NAT) |
| `SMTP_*` | Mailserver für Bestätigungs- und Passwort-Reset-Mails |
| `NTFY_BASE_URL` | Öffentliche URL des ntfy-Servers |
| `SHOPBANDIT_VERSION` | Image-Tag (`1.0.0`, `1.0`, `latest`) |

Die Werte werden bei jedem Start übernommen (Hook `onBootstrap`), Änderungen also mit `docker compose up -d` aktivieren.

### Entwicklung

`docker-compose.override.yml.example` nach `docker-compose.override.yml` kopieren: baut das Image lokal und bindet `pb_migrations/` und `pb_hooks/` aus dem Arbeitsverzeichnis ein. Test: `scripts/smoke-test.sh http://127.0.0.1:8090` (legt Wegwerf-Konten an – nicht gegen Produktion laufen lassen).

## Proxmox

- **Docker im LXC**: unprivilegierter Container mit `features: nesting=1,keyctl=1` (`pct set <id> --features nesting=1,keyctl=1`, danach Neustart des Containers), dann Docker installieren.
- **Docker-VM**: genauso, nur ohne Feature-Flags.
- **Ohne Docker** (z. B. in einem bestehenden LXC): Binaries nach `/opt/shopbandit/bin`, `pb_migrations/`, `pb_hooks/`, `.env` nach `/opt/shopbandit`, Benutzer `shopbandit` anlegen, `deploy/shopbandit-pocketbase.service` und `deploy/shopbandit-ntfy.service` nach `/etc/systemd/system/` kopieren, `systemctl enable --now shopbandit-pocketbase shopbandit-ntfy`. Die Units lauschen auf 8090/8091 an allen Interfaces – Zugriff per Firewall auf den Reverse Proxy beschränken.

## Reverse Proxy (HTTPS)

Wichtig für beide Dienste: **Antwort-Buffering aus** (PocketBase-Realtime nutzt Server-Sent Events, ntfy hält Verbindungen lange offen) und **lange Timeouts**.

### Caddy

```caddyfile
shop.example.com {
    reverse_proxy 127.0.0.1:8090 {
        flush_interval -1
        header_up X-Real-IP {remote_host}
    }
}

push.example.com {
    reverse_proxy 127.0.0.1:8091 {
        flush_interval -1
        transport http {
            read_timeout 0
        }
    }
}
```

### Nginx Proxy Manager

Je ein Proxy-Host für `shop.` (→ Port 8090) und `push.` (→ Port 8091):

- *Websockets Support*: an
- *Block Common Exploits*: an
- SSL: Let's-Encrypt-Zertifikat, *Force SSL*, *HTTP/2*
- *Advanced → Custom Nginx Configuration*:

```nginx
proxy_buffering off;
proxy_cache off;
proxy_read_timeout 3600s;
proxy_send_timeout 3600s;
client_max_body_size 5m;
```

NPM setzt `X-Real-IP` bereits selbst.

## ntfy für UnifiedPush

Die Compose-Datei (und die systemd-Unit) setzen:

- `auth-default-access: deny-all` – der Server ist kein offenes Relay,
- `auth-access: everyone:up*:read-write` – nur UnifiedPush-Themen (`up…`, zufällige Namen) sind offen.

Auf dem Handy: ntfy (F-Droid) installieren → *Einstellungen → Standard-Server* = `https://push.example.com`. Danach in ShopBandit Benachrichtigungen einschalten. Der Server sendet nur „wer“ und „wie viele“ (keine Artikelnamen), weil UnifiedPush-Nachrichten unverschlüsselt über den Verteiler laufen können.

## Updates

```sh
docker compose pull && docker compose up -d
```

Migrationen laufen beim Start automatisch. Vorher ein Backup machen.

## Backup und Restore

```sh
# Docker: Volume-Pfad ermitteln
PB_DATA=$(docker volume inspect -f '{{.Mountpoint}}' server_pb_data)
sudo server/scripts/backup.sh "$PB_DATA" /srv/backups/shopbandit 14
```

`backup.sh` nutzt die SQLite-Online-Backup-Funktion (`sqlite3 .backup`), damit der Snapshot auch bei laufendem Server konsistent ist, packt ihn als `shopbandit-<zeit>.tar.gz` und behält die letzten *N* Stück. Per Cron täglich laufen lassen, z. B.:

```cron
30 2 * * * root /opt/shopbandit/scripts/backup.sh /opt/shopbandit/pb_data /opt/shopbandit/backups 14 >/dev/null
```

**Restore**:

```sh
docker compose stop pocketbase
mkdir /tmp/restore && tar -xzf shopbandit-<zeit>.tar.gz -C /tmp/restore
sudo rsync -a --delete /tmp/restore/ "$PB_DATA"/
sudo chown -R 10001:10001 "$PB_DATA"
docker compose start pocketbase
```

(Ohne Docker: `systemctl stop shopbandit-pocketbase`, Archiv nach `/opt/shopbandit/pb_data` entpacken, Besitzer `shopbandit`, Dienst starten.)

## Sicherheit

- API-Regeln: Jeder sieht und ändert nur Daten seines Haushalts. `users.household` ändert nur der Server (Hooks), nie der Client.
- Einladungen: Token nur einmal im Klartext (QR-Code), gespeichert wird der SHA-256-Hash; 24 h gültig, einmalig, widerrufbar.
- Passwortregel (≥ 8 Zeichen, Groß-/Kleinbuchstabe, Ziffer, Sonderzeichen) wird im Hook geprüft, nicht nur in der App.
- Rate-Limits für Login, Registrierung, Passwort-Reset und Einladungen sind aktiv.
- Push-Endpunkte: nur `https`, keine IP-Adressen/localhost, optional Host-Allowlist (`SHOPBANDIT_PUSH_HOSTS`).
