#!/usr/bin/env bash
# Consistent snapshot of a PocketBase data directory (SQLite online backup),
# packed as tar.gz with rotation.
# Usage: backup.sh <pb_data dir> <backup dir> [keep=14]
#   Docker: backup.sh "$(docker volume inspect -f '{{.Mountpoint}}' server_pb_data)" /srv/backups/shopbandit
# Restore: stop PocketBase, extract the archive into an empty pb_data dir, start again.
set -euo pipefail
SRC="${1:?pb_data dir}"; DEST="${2:?backup dir}"; KEEP="${3:-14}"
command -v sqlite3 >/dev/null || { echo "sqlite3 missing" >&2; exit 1; }
TS=$(date +%Y%m%d-%H%M%S)
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
mkdir -p "$DEST"
for db in data.db auxiliary.db; do
  [ -f "$SRC/$db" ] && sqlite3 "$SRC/$db" ".backup '$TMP/$db'"
done
[ -d "$SRC/storage" ] && cp -a "$SRC/storage" "$TMP/"
tar -C "$TMP" -czf "$DEST/shopbandit-$TS.tar.gz" .
chmod 600 "$DEST/shopbandit-$TS.tar.gz"
ls -1t "$DEST"/shopbandit-*.tar.gz | tail -n +"$((KEEP + 1))" | xargs -r rm --
echo "$DEST/shopbandit-$TS.tar.gz"
