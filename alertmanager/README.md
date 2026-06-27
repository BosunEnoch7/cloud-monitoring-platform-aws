# Alertmanager

Contains Alertmanager routing, inhibition, and Slack notification configuration.

## Routing

- Warning alerts repeat every four hours.
- Critical alerts repeat hourly.
- Critical alerts inhibit equivalent warning alerts.
- Resolved notifications are sent automatically.

## Slack Secret

Create `alertmanager/secrets/slack_webhook_url` containing only the Slack incoming
webhook URL. Then set this path in `docker/.env`:

```text
ALERTMANAGER_SLACK_WEBHOOK_FILE=../alertmanager/secrets/slack_webhook_url
```

The real webhook file and `docker/.env` are ignored by Git. The committed
example webhook exists only for static configuration validation.
