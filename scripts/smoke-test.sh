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

curl -fsS http://localhost:9000/minio/health/live >/dev/null
curl -fsS http://localhost:8080 >/dev/null
curl -fsS http://localhost:8888/lab >/dev/null

if ! curl -fsS http://localhost:8080 | grep -q 'spark-worker'; then
  printf '%s\n' 'Spark Master UI did not report registered workers.' >&2
  exit 1
fi

compose ps
printf '%s\n' 'Iteration 1 smoke test passed.'
