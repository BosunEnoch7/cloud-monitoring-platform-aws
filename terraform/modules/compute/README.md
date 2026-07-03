# Compute Module

Owns the Ubuntu EC2 instance that will host the monitoring stack.

## Resources

- Latest Ubuntu 24.04 LTS AMI lookup
- EC2 security group
- Optional CIDR-restricted SSH ingress; disabled by default
- Outbound internet access for package installation
- EC2 instance with encrypted GP3 root volume
- IMDSv2 enforcement
- Docker Engine and Docker Compose plugin bootstrap
- CloudWatch Agent installation and log forwarding

## Bootstrap

Docker is installed from Docker's official Ubuntu repository. Bootstrap output
is written to `/var/log/cloud-monitoring-bootstrap.log`, and a successful run
creates `/var/lib/cloud-monitoring-bootstrap.complete`.

The CloudWatch Agent forwards system, Docker, and bootstrap logs to
Terraform-managed log groups. Log retention is owned by the CloudWatch module,
not by the instance configuration.

The security group has no ingress rules by default. Use SSM Session Manager and
port forwarding to reach services bound to the instance loopback interface.

Changing the bootstrap template replaces the development instance on the next
Terraform apply. Monitoring data must use persistent storage before this pattern
is promoted beyond development.

## Cost Notes

The default instance type is `t3.micro` and no Elastic IP is created. Public
IPv4 usage may still create charges depending on the AWS account and current
AWS pricing.
