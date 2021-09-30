#!/usr/bin/env sh

# Stop execution if we have an error
set -e

# Wait for Postgres to ready
# Environment variables are set in .env.web.prod file inside env directory
until PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -U "$DB_USER" -c '\q'; do
  >&2 echo "Postgres is down - Sleeping"
  sleep 1
done

>&2 echo "Postgres is up"

exec "$@"