#!/usr/bin/env bash
set -Eeuo pipefail

readonly REPOSITORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly COMPOSE_FILE="$REPOSITORY_ROOT/docker/compose.yml"
readonly EXAMPLE_ENV_FILE="$REPOSITORY_ROOT/docker/.env.example"
readonly PROMETHEUS_IMAGE="prom/prometheus:v3.5.0"
readonly ALERTMANAGER_IMAGE="prom/alertmanager:v0.28.1"

docker compose \
  --env-file "$EXAMPLE_ENV_FILE" \
  -f "$COMPOSE_FILE" \
  config --quiet

docker run --rm \
  --entrypoint /bin/promtool \
  -v "$REPOSITORY_ROOT/prometheus:/etc/prometheus:ro" \
  "$PROMETHEUS_IMAGE" \
  check config /etc/prometheus/prometheus.yml

docker run --rm \
  --entrypoint /bin/amtool \
  -v "$REPOSITORY_ROOT/alertmanager:/etc/alertmanager:ro" \
  "$ALERTMANAGER_IMAGE" \
  check-config /etc/alertmanager/alertmanager.yml

echo "Monitoring configuration is valid."
