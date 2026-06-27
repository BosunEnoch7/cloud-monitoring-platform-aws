# Troubleshooting Runbook

## Start With Scope

Identify whether the failure is in AWS provisioning, EC2 bootstrap, Docker,
metrics collection, visualization, alert delivery, or CloudWatch forwarding.
Avoid changing several layers at once.

## EC2 Is Not Online in SSM

Checks:

```bash
aws ec2 describe-instance-status --instance-ids INSTANCE_ID
aws ssm describe-instance-information
```

Likely causes:

- Instance bootstrap is still running.
- The IAM instance profile is missing or not attached.
- The instance has no outbound route to SSM endpoints.
- The SSM Agent service is stopped.

Use EC2 console output and `/var/log/cloud-init-output.log` if session access is
not available.

## Bootstrap Failed

```bash
sudo cloud-init status --long
sudo tail -n 200 /var/log/cloud-monitoring-bootstrap.log
sudo journalctl -u cloud-final --no-pager
```

The completion marker should exist:

```bash
test -f /var/lib/cloud-monitoring-bootstrap.complete
```

Common causes are package-repository connectivity, a failed CloudWatch Agent
download, or an invalid generated agent configuration.

## Containers Are Not Healthy

```bash
docker compose --env-file docker/.env -f docker/compose.yml ps
docker compose --env-file docker/.env -f docker/compose.yml logs --tail=200 SERVICE
docker inspect --format '{{json .State.Health}}' CONTAINER
```

Revalidate before restarting:

```bash
bash scripts/validate-monitoring.sh
```

Do not delete named volumes until configuration and permissions have been
checked; doing so removes stored metrics and Grafana state.

## Prometheus Target Is Down

```bash
docker exec prometheus wget -qO- http://node-exporter:9100/metrics | head
docker exec prometheus wget -qO- http://cadvisor:8080/metrics | head
docker exec prometheus wget -qO- http://alertmanager:9093/-/ready
```

Check the Compose network, target service health, and target names in
`prometheus/prometheus.yml`.

## Grafana Has No Data

1. Confirm the Prometheus datasource is healthy in Grafana.
2. Confirm Prometheus targets are up.
3. Run a basic query such as `up`.
4. Check that recording rules exist and evaluate successfully.
5. Widen the dashboard time range if the stack was just started.

Provisioned dashboards are intentionally not editable in the UI. Change the
JSON in Git and redeploy.

## Alerts Do Not Reach Slack

```bash
docker compose --env-file docker/.env -f docker/compose.yml logs alertmanager
docker exec alertmanager amtool config show
```

Confirm:

- `alertmanager/secrets/slack_webhook_url` contains only the webhook URL.
- `docker/.env` points to the real secret file.
- The Slack channel exists and the webhook can post to it.
- The alert is pending or firing in Prometheus.
- Alertmanager inhibition or grouping is not delaying the notification.

## CloudWatch Logs Are Missing

```bash
sudo systemctl status amazon-cloudwatch-agent
sudo tail -n 200 /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
sudo cat /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
```

Confirm the log groups exist, the IAM policy path matches project/environment,
and source files such as `/var/log/syslog` exist.

## SSM Port Forwarding Fails

- Confirm the instance is online in Systems Manager.
- Confirm the Session Manager plugin is installed locally.
- Confirm the target container is healthy and bound to `127.0.0.1`.
- Check whether another local process already uses the requested port.

## Terraform State or Lock Errors

This development environment currently uses local state. Do not run Terraform
from multiple workstations. Back up the state securely and migrate to the
documented S3 backend before team use. Never commit state files.
