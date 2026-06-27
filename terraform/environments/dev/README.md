# Dev Environment

The `dev` environment is the first deployable version of the platform.

It will call the reusable Terraform modules and define development-specific values such as region, CIDR ranges, instance size, and naming prefixes.

The default security group has no ingress. Administration and dashboard access
use Systems Manager Session Manager. Set `enable_ssh = true` only for a
time-limited troubleshooting exception and restrict `admin_access_cidr` to a
single trusted `/32`.
