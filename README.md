<p align="center"><img src="app/assets/branding/store-icon.png" width="128" alt="ShopBandit"></p>

<h1 align="center">ShopBandit</h1>

<p align="center">
Gemeinsame Einkaufsliste für Android – offline-first, ohne Google, mit eigenem Server.<br>
Shared shopping list for Android – offline-first, Google-free, self-hosted backend.
</p>

[Deutsch](#deutsch) · [English](#english)

---

## Deutsch

### Funktionen

- **Eine Liste pro Haushalt**: Artikel + optionale Menge („2“, „500 g“), abhaken = gekauft (mit „Rückgängig“), wischen = löschen, antippen = Menge ändern. Man sieht dezent, wer etwas hinzugefügt hat.
- **Offline-first**: Alles landet sofort in der lokalen Datenbank und wird synchronisiert, sobald eine Verbindung besteht. Live-Updates, solange die App offen ist.
- **Artikelkatalog & „Häufig gekauft“**: Autovervollständigung, Vorschläge nach Häufigkeit (jüngere Käufe zählen mehr).
- **Haushalt / Familie**: Einladung per QR-Code (24 h gültig, einmalig, widerrufbar), Mitglieder entfernen, Haushalt verlassen.
- **Benachrichtigungen ohne Google**: [UnifiedPush](https://unifiedpush.org) über einen eigenen [ntfy](https://ntfy.sh)-Server; ohne Push-App prüft die App etwa alle 15 Minuten.
- **Datenschutz**: Kein Firebase, keine Tracker, keine Google-Play-Dienste. Der Server gehört dir.
- Deutsch und Englisch, heller und dunkler Modus.

### Screenshots

_Folgen._ (`fastlane/metadata/android/*/images/phoneScreenshots/`)

### App installieren

- **GitHub-Releases**: signierte APKs (pro ABI + universell) unter [Releases](https://github.com/CrashBandit82/shopbandit/releases).
- **F-Droid**: in Vorbereitung.

Quellcode auch auf GitLab (Spiegel): https://gitlab.com/CrashBandit82/shopbandit

Beim ersten Start fragt die App nach der Server-Adresse (Standard: `https://shop.macrobandit.at`). Du kannst jeden eigenen ShopBandit-Server eintragen.

**Sofortige Benachrichtigungen**: [ntfy aus F-Droid](https://f-droid.org/packages/io.heckel.ntfy/) installieren, in ntfy den eigenen Server als Standard-Server eintragen (z. B. `https://push.example.com`), dann in ShopBandit unter *Einstellungen → Benachrichtigungen* einschalten.

### Server betreiben

Kurzfassung (Details: [docs/SERVER.md](docs/SERVER.md)):

```sh
git clone https://github.com/CrashBandit82/shopbandit && cd shopbandit/server
cp .env.example .env        # Domain, SMTP, Push-Hosts eintragen
docker compose up -d
docker compose exec pocketbase /pb/pocketbase superuser upsert admin@example.com 'EinLangesPasswort!1' --dir=/pb/pb_data
```

- Läuft auf einem Proxmox-Host als **Docker in einem LXC** (`nesting=1`, `keyctl=1`) oder in einer Docker-VM. Ohne Docker: `server/deploy/*.service` (systemd, siehe SERVER.md).
- **Reverse Proxy mit HTTPS** davor (Caddy oder Nginx Proxy Manager). Wichtig: **Buffering für SSE abschalten** (PocketBase-Realtime) und lange Timeouts für ntfy.
- **Updates**: `docker compose pull && docker compose up -d`
- **Backups**: `server/scripts/backup.sh` (konsistenter SQLite-Snapshot mit Rotation), Restore-Anleitung in SERVER.md.

### App bauen

```sh
cd app
../tools/fetch-sqlite.sh        # SQLite-Quellcode (wird mitkompiliert)
flutter pub get
dart run build_runner build -d   # Drift-Code
flutter test
flutter build apk --release --split-per-abi
```

Flutter 3.47.7 (stable). Release-Signatur über `android/key.properties` oder Umgebungsvariablen, siehe [docs/RELEASE.md](docs/RELEASE.md).

### Lizenz

[GPL-3.0](LICENSE) © CrashBandit82

---

## English

### Features

- **One list per household**: item + optional quantity, check off = bought (with undo), swipe = delete, tap = edit quantity, subtle "added by".
- **Offline-first**: local database first, synced when online; live updates while the app is open.
- **Item catalog & "Frequently bought"**: autocomplete and suggestions weighted towards recent purchases.
- **Household / family**: invite via QR code (24 h, single use, revocable), remove members, leave.
- **Notifications without Google**: [UnifiedPush](https://unifiedpush.org) via your own [ntfy](https://ntfy.sh) server; without a distributor app the app checks about every 15 minutes.
- **Privacy**: no Firebase, no trackers, no Google Play Services. You own the server.
- German and English, light and dark mode.

### Install

Signed APKs on [GitHub Releases](https://github.com/CrashBandit82/shopbandit/releases); F-Droid in preparation. On first start, enter your server address (default `https://shop.macrobandit.at`).

For instant notifications install [ntfy from F-Droid](https://f-droid.org/packages/io.heckel.ntfy/), set your own server as its default server, then enable notifications in ShopBandit's settings.

### Run a server

```sh
git clone https://github.com/CrashBandit82/shopbandit && cd shopbandit/server
cp .env.example .env
docker compose up -d
docker compose exec pocketbase /pb/pocketbase superuser upsert admin@example.com 'ALongPassword!1' --dir=/pb/pb_data
```

Put a reverse proxy with HTTPS in front (Caddy / Nginx Proxy Manager) and **disable buffering for SSE**. Updates: `docker compose pull && docker compose up -d`. Backups: `server/scripts/backup.sh`. Details, Proxmox notes and proxy examples: [docs/SERVER.md](docs/SERVER.md).

### Build

See the German section above (`flutter pub get`, `dart run build_runner build -d`, `flutter build apk`). Release signing: [docs/RELEASE.md](docs/RELEASE.md).

### License

[GPL-3.0](LICENSE) © CrashBandit82
