# Portfolio Evidence

These screenshots were captured from a real short-lived AWS deployment. Account
IDs, public IPs, email addresses, webhook URLs, tokens, and secrets must remain
excluded.

## Captured Evidence

- `grafana-platform-overview.png`: host and Docker telemetry
- `prometheus-targets.png`: four healthy scrape targets
- `prometheus-alerts.png`: six provisioned alert rules
- `alertmanager-status.png`: Alertmanager runtime UI
- `cloudwatch-alarms-console.png`: two healthy EC2 alarms
- `cloudwatch-status-alarm-detail.png`: EC2 status-check alarm graph

Recommended evidence:

1. GitHub Actions with all three validation jobs passing
2. Terraform plan summary
3. AWS VPC and EC2 resource tags
4. EC2 shown online in Systems Manager
5. Grafana overview dashboard with populated panels
6. Prometheus targets page showing all targets up
7. A firing test alert and its resolved Slack notification
8. CloudWatch log streams receiving system and Docker logs
9. CloudWatch alarms connected to the SNS topic
10. Terraform destroy summary after the demonstration

Use descriptive filenames such as `grafana-platform-overview.png`. Do not commit
screenshots from an empty or partially failed deployment.
