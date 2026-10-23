#!/bin/sh
set -eu

COMPOSE_FILE="infra/docker-compose.yml"
ENV_FILE="infra/.env"

if [ ! -f "$ENV_FILE" ]; then
  printf '%s\n' "Missing $ENV_FILE. Copy infra/.env.example to infra/.env first." >&2
  exit 1
fi

compose() {
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" "$@"
}

compose config --quiet

compose exec -T garage /garage -c /etc/garage.toml status >/dev/null
curl -fsS http://localhost:8080 >/dev/null
curl -fsS http://localhost:8888/lab >/dev/null

if ! curl -fsS http://localhost:8080 | grep -qE 'Workers \([2-9][0-9]*\)'; then
  printf '%s\n' 'Spark Master UI did not report at least two registered workers.' >&2
  exit 1
fi

compose ps
printf '%s\n' 'Iteration 1 smoke test passed.'
