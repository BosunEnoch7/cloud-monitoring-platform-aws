# Terraform

Terraform is organized into reusable ownership modules and one development
environment.

```text
terraform/
|-- modules/
|   |-- network/
|   |-- compute/
|   |-- iam/
|   `-- cloudwatch/
`-- environments/
    `-- dev/
```

## Module Responsibilities

- `network`: VPC, public subnet, internet gateway, and route table
- `compute`: security group, Ubuntu EC2, encrypted EBS, and bootstrap
- `iam`: EC2 role, SSM policy, and scoped CloudWatch Logs policy
- `cloudwatch`: log groups, retention, EC2 alarms, and SNS

## Local Validation

```bash
terraform fmt -check -recursive
terraform -chdir=environments/dev init -backend=false
terraform -chdir=environments/dev validate
```

State and `.tfvars` files are excluded from Git. Review
`docs/deployment-guide.md` before planning or applying.
