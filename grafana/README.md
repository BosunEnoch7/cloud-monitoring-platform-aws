# Grafana

Contains version-controlled Grafana provisioning and dashboards.

## Provisioned Resources

- Prometheus datasource using the private Compose network
- `Cloud Monitoring Platform Overview` dashboard
- Persistent Grafana data volume

The dashboard covers host CPU, memory, filesystem, network, uptime, and Docker
container resource usage.

## Credentials

Create `docker/.env` from `docker/.env.example` and replace the example password
before starting the stack. The real `.env` file is ignored by Git.
