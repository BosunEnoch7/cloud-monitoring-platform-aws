# Docker

Contains the Docker Compose configuration for Prometheus, Grafana,
Alertmanager, and supporting exporters.

Docker Engine and the Compose plugin are installed during EC2 bootstrap by the
Terraform compute module.

## Phase 6 Services

- Prometheus `v3.5.0`
- Node Exporter `v1.9.1`
- cAdvisor `v0.52.1`
- Grafana `12.1.1`
- Alertmanager `v0.28.1`

Grafana, Prometheus, and Alertmanager bind only to the host loopback interface.
Exporter ports remain private to the Compose network. Images are pinned so
deployments are reproducible.

Start the metrics layer from the repository root:

```bash
docker compose --env-file docker/.env -f docker/compose.yml up -d
```
