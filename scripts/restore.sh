#!/usr/bin/env bash
# Download the OMDB snapshot from this repo's GitHub release and restore it
# into a local Postgres database (default: omdb on localhost:5432).
#
#   ./scripts/restore.sh            # uses PGHOST/PGPORT/PGUSER/PGPASSWORD if set
#   DB=omdb_test ./scripts/restore.sh
set -euo pipefail

DB="${DB:-omdb}"
URL="${OMDB_DUMP_URL:-https://github.com/nlaratta/db-tinkering/releases/download/omdb-2025-02/omdb.dump}"
DUMP="${DUMP:-$(dirname "$0")/../omdb.dump}"

if [[ ! -f "$DUMP" ]]; then
  echo "Downloading $URL"
  curl -fL --retry 3 -o "$DUMP" "$URL"
fi

createdb "$DB" 2>/dev/null || echo "Database $DB already exists, restoring into it"
# --no-owner: the dump was made as the postgres role; restore as whoever you are.
# The only expected warning is "schema public already exists".
pg_restore --no-owner -d "$DB" "$DUMP" || true

movies=$(psql -d "$DB" -Atc "select count(*) from movies")
echo "Restored $DB: $movies movies"
[[ "$movies" -gt 200000 ]]
