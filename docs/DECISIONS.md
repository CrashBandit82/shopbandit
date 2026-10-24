# Entscheidungen und Annahmen

| # | Entscheidung | Grund |
|---|---|---|
| 1 | Lizenz **GPL-3.0** | F-Droid-tauglich, Vorgabe aus dem Auftrag. |
| 2 | Package-ID `at.macrobandit.shopbandit`, Name in `app/lib/core/constants.dart` | Endgültig ab dem ersten Release. |
| 3 | Gepinnte Versionen: Flutter 3.47.7, PocketBase 0.40.5, ntfy 2.29.0 | Jeweils ≥ 2 Wochen alt zum Projektstart (2026-10-24). |
| 4 | **Client-IDs**: Listeneinträge zufällig (15 Zeichen a–z0–9, PocketBase-Format); Katalogartikel **deterministisch** `sha256(haushalt|name_normalisiert)` | Offline sofort referenzierbar; zwei Geräte, die denselben neuen Artikel offline anlegen, erzeugen denselben Datensatz statt eines Duplikats. |
| 5 | **Konfliktlösung**: Updates senden nur geänderte Felder (Last-Write-Wins pro Feld, Reihenfolge = Ankunft am Server). Datensätze mit ausstehender lokaler Änderung werden beim Pull nicht überschrieben. Kaufzähler als relatives `purchase_count+ / -` | Parallele Käufe auf zwei Handys addieren sich korrekt. |
| 6 | **Löschen = Tombstone** (`deleted = true`), Abhaken = `checked = true` | Offline-Löschungen synchronisieren zuverlässig; keine harten Deletes durch Clients (API erlaubt keine). |
| 7 | **Outbox** in Drift, FIFO, Backoff 2^n s (max. 5 min). 400/403/404 → Änderung verwerfen, 401/429/5xx/offline → später erneut | Eine kaputte Änderung blockiert nicht die Warteschlange. |
| 8 | Delta-Pull per `updated >= cursor` + Realtime (SSE) solange die App offen ist; bei Realtime-Reconnect und App-Resume voller Delta-Sync, zusätzlich alle 2 min | Robuster als nur Realtime. |
| 9 | **Haushalt**: Ersteller = Admin (`households.owner`). Verlässt der Admin den Haushalt, geht die Rolle an das älteste Mitglied. Beim Beitritt wird ein Einzelhaushalt samt Liste/Katalog gelöscht (Hinweis im Bestätigungsdialog); Mitglieder entfernen/Verlassen → eigener neuer Haushalt | Spec: „ggf. bisherigen leeren Einzelhaushalt verwerfen“. |
| 10 | Haushalt umbenennen (nur Admin) | Klein, ohne Umweg über das Dashboard. |
| 11 | **Einladungstoken**: 24 Zeichen (ohne verwechselbare Zeichen), gespeichert nur als SHA-256 | Token in DB-Backups nicht nutzbar. QR enthält auch die Server-URL; Einladung zu anderem Server wird abgelehnt. |
| 12 | **Push-Inhalt ohne Artikelnamen** (`{type, by, count}`), unverschlüsselt | UnifiedPush-Connector 3.x akzeptiert Klartext; WebPush-Verschlüsselung im PocketBase-JSVM wäre aufwendig. Ohne Namen ist der Klartext unkritisch. |
| 13 | Push-Bündelung: Cron jede Minute, Einträge ≥ 20 s alt, Markierung `notified` | Mehrere Artikel → eine Nachricht; eigene Einträge lösen keine Push aus. |
| 14 | Push-Endpunkte nur `https`, keine IPs/localhost, optionale Allowlist | Verhindert SSRF über den Server. |
| 15 | Direkt `unifiedpush_android` statt `unifiedpush` | Das Wrapper-Paket zieht die Linux-Implementierung mit nativem BoringSSL-Build (webcrypto) in die APK. |
| 16 | `tink` → `tink-android` (Gradle-Substitution) | UnifiedPush-Connector und flutter_secure_storage bringen dieselben Klassen in zwei Varianten mit. |
| 17 | QR-Scanner `flutter_zxing` (zxing-cpp), QR-Anzeige `qr_flutter` | FOSS, kein ML Kit. |
| 18 | SQLite für F-Droid aus dem Quellcode (Hook-Option `sqlite3: source: source`) | Das `sqlite3`-Paket lädt sonst eine vorkompilierte Bibliothek. Siehe `docs/fdroid/`. |
| 19 | Fallback ohne Push-Verteiler: WorkManager alle 15 min (Android-Minimum) | Spec. |
| 20 | E-Mail-Bestätigung wird angefordert, Login ist aber auch unbestätigt möglich | App bleibt ohne funktionierendes SMTP nutzbar; Hinweis in den Einstellungen. |
| 21 | **Logo**: Quelle ist ein JPEG mit eingebranntem Schachbrett-Hintergrund, Maskottchen blau auf blauem Verlauf → keine saubere Freistellung möglich. Übergangslösung `tools/make_branding.py`: ganze Logo-Kachel über Verlaufshintergrund; **kein Monochrom-Icon** | Spec: „sag Bescheid statt hochzuskalieren“. Für finale Icons: Maskottchen als PNG mit echter Transparenz. |
| 22 | Farben: feste Palette (keine dynamischen Farben), geprüft nach WCAG AA: Weiß auf `#2162B6` 6.0:1, Text auf Orange dunkel (`#1F1300`, 7.4:1), Erfolgsgrün hell `#2E7D32` (4.8:1), Navy-Dunkelmodus `#0F1B2D` | Weiß auf Cyan (2.3:1) wäre zu schwach → Header-Text sitzt auf dem blauen Ende des Verlaufs. |
