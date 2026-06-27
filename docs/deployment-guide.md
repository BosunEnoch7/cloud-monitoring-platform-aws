# Deployment Guide

This deployment creates billable AWS resources. Review `docs/cost-control.md`
first and destroy the environment when testing is complete.

## Prerequisites

- AWS account and AWS CLI credentials
- Terraform 1.6 or newer
- AWS Session Manager plugin
- Git
- Slack incoming webhook for Alertmanager

## 1. Configure Terraform

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
```

Review region, Availability Zone, instance type, retention, and email values.
Keep `enable_ssh = false`. Confirm the active AWS identity:

```bash
aws sts get-caller-identity
```

## 2. Validate and Review

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
terraform show tfplan
```

Read the complete plan before continuing. Terraform state is local until the
remote backend described in `terraform/environments/dev/backend.tf` is enabled.

## 3. Create AWS Resources

```bash
terraform apply tfplan
terraform output
```

If `alert_email` is configured, confirm the SNS subscription email. Wait until
the instance appears as online in Systems Manager.

## 4. Deliver the Monitoring Configuration

Start a Session Manager shell:

```bash
aws ssm start-session --target INSTANCE_ID
```

On EC2, clone the repository at a reviewed commit:

```bash
sudo -u ubuntu git clone REPOSITORY_URL /opt/cloud-monitoring-platform/repository
cd /opt/cloud-monitoring-platform/repository
sudo -u ubuntu git checkout REVIEWED_COMMIT_SHA
```

Create runtime secrets:

```bash
sudo -u ubuntu cp docker/.env.example docker/.env
sudo -u ubuntu mkdir -p alertmanager/secrets
sudo -u ubuntu sh -c 'printf "%s\n" "SLACK_WEBHOOK_URL" > alertmanager/secrets/slack_webhook_url'
sudo -u ubuntu chmod 600 docker/.env alertmanager/secrets/slack_webhook_url
```

Edit `docker/.env` and replace the Grafana password. Set:

```text
ALERTMANAGER_SLACK_WEBHOOK_FILE=../alertmanager/secrets/slack_webhook_url
```

Deploy as the `ubuntu` user:

```bash
sudo -u ubuntu bash scripts/deploy-monitoring.sh
```

## 5. Access Grafana

From the local workstation:

```bash
aws ssm start-session \
  --target INSTANCE_ID \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["3000"],"localPortNumber":["3000"]}'
```

Open `http://127.0.0.1:3000`. Prometheus and Alertmanager can be tunneled using
ports `9090` and `9093`.

## 6. Smoke Tests

```bash
docker compose --env-file docker/.env -f docker/compose.yml ps
curl --fail http://127.0.0.1:9090/-/ready
curl --fail http://127.0.0.1:9093/-/ready
curl --fail http://127.0.0.1:3000/api/health
```

Verify all Prometheus targets are up, the Grafana dashboard has data, CloudWatch
log streams exist, and the SNS subscription is confirmed.

## Teardown

Preserve any screenshots or evidence needed for the portfolio, then:

```bash
cd terraform/environments/dev
terraform plan -destroy -out=destroy.tfplan
terraform apply destroy.tfplan
```

Confirm that EC2, EBS, log groups, alarms, and SNS resources are gone.
