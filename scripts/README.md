# Scripts

Operational scripts for validation and maintenance belong here.

The EC2 bootstrap template is kept inside `terraform/modules/compute/templates`
because it is part of the compute module's deployment contract.

- `validate-monitoring.sh` validates Compose, Prometheus, and Alertmanager.
- `deploy-monitoring.sh` validates, pulls, and starts the monitoring stack.
