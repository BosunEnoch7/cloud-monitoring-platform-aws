# Interview Guide

## Two-Minute Explanation

This project provisions a cost-aware AWS monitoring host with modular Terraform.
Ubuntu bootstrap installs Docker and CloudWatch Agent. Docker Compose runs
Prometheus, Node Exporter, cAdvisor, Grafana, and Alertmanager. Prometheus
collects host and container metrics, Grafana provisions dashboards from Git,
and Alertmanager routes severity-based Slack notifications. CloudWatch receives
logs and provides native EC2 alarms through SNS. GitHub Actions validates every
configuration without holding AWS credentials.

## Design Questions

**Why one EC2 instance?**

It keeps a portfolio environment understandable and inexpensive. The
documentation clearly identifies the availability tradeoff and the path toward
a multi-node or managed platform.

**Why both Prometheus and CloudWatch?**

Prometheus handles detailed workload telemetry and PromQL alerting. CloudWatch
handles AWS-native logs and infrastructure health. They solve related but
different operational needs.

**Why no public Grafana port?**

The development environment uses SSM port forwarding. This removes default
inbound rules and avoids presenting an unencrypted login page to the internet.

**How are secrets handled?**

Secrets are runtime files excluded from Git. A production evolution would use
AWS Secrets Manager or Parameter Store and automated secret delivery.

**What is the main production gap?**

The platform is a single-host development architecture with local Terraform
state. High availability, remote state, HTTPS ingress, centralized secrets,
durable metrics storage, and automated recovery are the next priorities.
