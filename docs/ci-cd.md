# CI/CD

GitHub Actions validates every relevant pull request and push to `main`.

## Validation Jobs

- Terraform formatting, initialization without the backend, and validation
- Docker Compose, Prometheus rules, and Alertmanager configuration
- Grafana dashboard JSON structure
- Trivy configuration scanning for high and critical findings

The workflow has read-only repository permissions and receives no AWS
credentials. It cannot create, modify, or destroy infrastructure.

## Future Deployment Workflow

Infrastructure deployment should use GitHub's OpenID Connect integration with a
dedicated AWS IAM role. A protected GitHub environment should require manual
approval before `terraform apply`. Long-lived AWS access keys must not be stored
as repository secrets.

Recommended deployment controls:

- Run `terraform plan` on pull requests and retain the plan as an artifact.
- Require review before applying from the protected `dev` environment.
- Apply only the reviewed plan from the default branch.
- Serialize deployments with a concurrency group.
- Store Terraform state in encrypted S3 with state locking.
