# Cost Control

This project is designed to be cost-aware, but AWS resources are not guaranteed to be free.

CloudWatch Logs ingestion and storage, CloudWatch alarms, and SNS delivery can
incur charges. Development log retention defaults to seven days, and the email
subscription is disabled unless `alert_email` is explicitly configured.

## Current Cost-Aware Defaults

- `t3.micro` EC2 instance type
- No Elastic IP
- 12 GiB encrypted GP3 root volume
- Single public subnet
- No NAT Gateway
- No Load Balancer
- No RDS or managed Kubernetes

## Important Notes

- Public IPv4 addresses may create hourly charges.
- EC2 usage may be free only if the AWS account is eligible and stays within free-tier limits.
- CloudWatch Logs and metrics have free allowances, but usage beyond those allowances may cost money.
- Always run `terraform destroy` when you are finished testing.

## Before Applying

Keep SSH disabled and use SSM Session Manager:

```hcl
enable_ssh = false
```

If a temporary SSH exception is required, set `enable_ssh = true` and replace
the documentation-only `admin_access_cidr` with your public IP `/32`.
