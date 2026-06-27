#!/usr/bin/env bash
set -Eeuo pipefail

readonly REPOSITORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly COMPOSE_FILE="$REPOSITORY_ROOT/docker/compose.yml"
readonly ENV_FILE="$REPOSITORY_ROOT/docker/.env"
readonly SLACK_SECRET="$REPOSITORY_ROOT/alertmanager/secrets/slack_webhook_url"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing $ENV_FILE. Create it from docker/.env.example." >&2
  exit 1
fi

if [[ ! -f "$SLACK_SECRET" ]]; then
  echo "Missing $SLACK_SECRET. Add the Slack webhook URL before deployment." >&2
  exit 1
fi

docker info >/dev/null
bash "$REPOSITORY_ROOT/scripts/validate-monitoring.sh"

docker compose \
  --env-file "$ENV_FILE" \
  -f "$COMPOSE_FILE" \
  pull

docker compose \
  --env-file "$ENV_FILE" \
  -f "$COMPOSE_FILE" \
  up --detach --remove-orphans

docker compose \
  --env-file "$ENV_FILE" \
  -f "$COMPOSE_FILE" \
  ps
