# Security Considerations

## Implemented Controls

- EC2 uses an IAM role; no static AWS credentials are stored on the host.
- IMDSv2 is required with a hop limit of one.
- The root EBS volume and SNS topic are encrypted.
- The security group has no ingress by default.
- Systems Manager Session Manager is the default administrative path.
- SSH is disabled at the network layer unless `enable_ssh = true`.
- SSH password and root authentication are disabled on the host.
- CloudWatch permissions are scoped to this project's log-group paths.
- Grafana, Prometheus, and Alertmanager bind to `127.0.0.1`.
- Container filesystems are read-only where practical, Linux capabilities are
  dropped, and `no-new-privileges` is enabled.
- Docker logs rotate at 10 MB with three retained files.
- Ubuntu unattended security updates are enabled.
- Grafana and Slack credentials are excluded from Git.

## Access Through SSM

Start a local tunnel to Grafana:

```bash
aws ssm start-session \
  --target INSTANCE_ID \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["3000"],"localPortNumber":["3000"]}'
```

Then open `http://127.0.0.1:3000`. Use ports `9090` and `9093` for Prometheus
and Alertmanager when troubleshooting.

## Accepted Development Risks

- The instance is in a public subnet and receives a public IPv4 address for
  package downloads. It has no default inbound rules.
- Outbound access is unrestricted because the host must reach package
  repositories, image registries, SSM, CloudWatch, and Slack without a NAT
  gateway or VPC endpoints.
- SNS uses the AWS-managed service key to avoid the fixed cost of a
  customer-managed KMS key in this development environment.
- Grafana uses HTTP over an encrypted SSM tunnel. A production shared service
  should terminate HTTPS at a controlled ingress layer.
- cAdvisor runs privileged and reads host runtime paths. This is required for
  its Docker visibility and makes it the highest-risk container.
- The SSM managed policy is AWS-managed and broader than the custom CloudWatch
  Logs policy.
- Container images are pinned to versions but not immutable digests.

These three cost-driven infrastructure decisions are explicit Trivy exceptions
in `.trivyignore`; all other high and critical findings remain blocking.

## Production Evolution

- Move the host to a private subnet and use VPC endpoints for SSM, CloudWatch,
  ECR or S3 as required.
- Put Grafana behind an authenticated HTTPS ingress such as an ALB with ACM.
- Pin Actions and container images by immutable digest.
- Add image signing, SBOM generation, and vulnerability policy enforcement.
- Store Terraform state in encrypted S3 with locking and tightly scoped access.
