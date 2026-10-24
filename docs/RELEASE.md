# Release

## Einmalig: Keystore

```sh
keytool -genkeypair -v -keystore shopbandit-release.jks -alias shopbandit \
  -keyalg RSA -keysize 4096 -validity 36500 -dname "CN=ShopBandit"
```

Der Keystore **nie** ins Repo (`.gitignore` deckt `*.jks` und `key.properties` ab). Sicher aufbewahren – ohne ihn können keine Updates mehr signiert werden.

GitHub → *Settings → Secrets and variables → Actions*:

| Secret | Inhalt |
|---|---|
| `SHOPBANDIT_KEYSTORE_BASE64` | `base64 -w0 shopbandit-release.jks` |
| `SHOPBANDIT_KEYSTORE_PASSWORD` | Store-Passwort |
| `SHOPBANDIT_KEY_ALIAS` | `shopbandit` |
| `SHOPBANDIT_KEY_PASSWORD` | Key-Passwort |

Lokal signieren: `app/android/key.properties`

```properties
storeFile=/pfad/zu/shopbandit-release.jks
storePassword=...
keyAlias=shopbandit
keyPassword=...
```

## Neue Version

1. `app/pubspec.yaml`: `version: X.Y.Z+N` – `N` (versionCode) **immer** erhöhen.
2. Changelog: `fastlane/metadata/android/{de-DE,en-US}/changelogs/N.txt`.
3. Commit, dann Tag: `git tag -a vX.Y.Z -m "ShopBandit X.Y.Z" && git push origin main vX.Y.Z`.
4. GitHub Actions:
   - **Release**: Tests, signierte APKs (arm64-v8a, armeabi-v7a, x86_64 + universell) + `SHA256SUMS` im GitHub-Release.
   - **Server image**: `ghcr.io/crashbandit82/shopbandit-server:{X.Y.Z, X.Y, latest, sha-…}` für amd64 + arm64.
5. F-Droid erkennt neue Tags automatisch (`AutoUpdateMode: Version`, `UpdateCheckMode: Tags`).

Der Workflow bricht ab, wenn Tag und `pubspec.yaml`-Version nicht übereinstimmen.

## Server aktualisieren

Docker: `docker compose pull && docker compose up -d`. Nativ (systemd): `pb_migrations/` und `pb_hooks/` des Tags nach `/opt/shopbandit/` kopieren, `systemctl restart shopbandit-pocketbase`. Vorher Backup (`scripts/backup.sh`).
