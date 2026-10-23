#!/bin/sh
set -eu

COMPOSE_FILE="infra/docker-compose.yml"
ENV_FILE="infra/.env"

if [ ! -f "$ENV_FILE" ]; then
  printf '%s\n' "Missing $ENV_FILE. Copy infra/.env.example to infra/.env first." >&2
  exit 1
fi

# Load local, Git-ignored credentials for the initialization commands.
. "$ENV_FILE"

compose() {
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" "$@"
}

garage() {
  compose exec -T garage /garage -c /etc/garage.toml "$@"
}

until garage status >/dev/null 2>&1; do
  sleep 2
done

node_id=$(garage node id | awk '{print $1}' | cut -d@ -f1)
garage layout assign -z local -c 10G "$node_id" >/dev/null 2>&1 || true
garage layout apply --version 1 >/dev/null 2>&1 || true

garage key import --yes -n garage-admin "$GARAGE_ADMIN_ACCESS_KEY" "$GARAGE_ADMIN_SECRET_KEY" >/dev/null 2>&1 || true
garage key import --yes -n garage-student "$GARAGE_STUDENT_ACCESS_KEY" "$GARAGE_STUDENT_SECRET_KEY" >/dev/null 2>&1 || true

garage bucket create datasets >/dev/null 2>&1 || true
garage bucket create student-results >/dev/null 2>&1 || true
garage bucket allow datasets --key "$GARAGE_ADMIN_ACCESS_KEY" --read --write --owner >/dev/null 2>&1 || true
garage bucket allow student-results --key "$GARAGE_ADMIN_ACCESS_KEY" --read --write --owner >/dev/null 2>&1 || true
garage bucket allow datasets --key "$GARAGE_STUDENT_ACCESS_KEY" --read --write >/dev/null 2>&1 || true
garage bucket allow student-results --key "$GARAGE_STUDENT_ACCESS_KEY" --read --write >/dev/null 2>&1 || true

printf '%s\n' 'Garage layout, keys, buckets, and permissions are ready.'
