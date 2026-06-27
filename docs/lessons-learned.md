# Lessons Learned

## Observability Needs More Than Dashboards

A credible monitoring platform combines collection, storage, visualization,
alert routing, runbooks, and an operational access model. A dashboard alone
does not show how an engineer detects and responds to failure.

## Cost and Security Shape Architecture

A single public-subnet EC2 instance keeps the demonstration affordable, but it
does not require public inbound access. SSM provides administration and port
forwarding while the security group remains closed by default.

## Overlapping Tools Can Have Clear Roles

Prometheus provides high-resolution host and container telemetry. CloudWatch
provides AWS-native logs, EC2 health alarms, and SNS integration. The overlap is
intentional and reflects how platform teams often combine cloud-native and
open-source observability.

## Reproducibility Requires Configuration as Code

Grafana datasources, dashboards, Prometheus rules, Alertmanager routing, and
Docker services are all version-controlled. Manual UI configuration would be
harder to review, reproduce, and demonstrate in an interview.

## Least Privilege Is Iterative

The initial CloudWatch managed policy made integration easy but was broader than
required. Replacing it with log-group-scoped permissions produced a stronger
final design while preserving the AWS-managed SSM core policy.

## Small Hosts Force Useful Constraints

Running the stack on a 1 GiB instance required explicit memory limits, short
metrics retention, bounded Docker logs, and restrained CloudWatch retention.
These constraints make cost and capacity decisions visible rather than hiding
them behind oversized infrastructure.

## What I Would Build Next

- Remote Terraform state with encryption and locking
- GitHub OIDC deployment role and protected apply workflow
- Private subnets and VPC endpoints
- HTTPS ingress and centralized secret management
- Highly available Prometheus storage and tested backup recovery
- Synthetic probes and service-level objectives
