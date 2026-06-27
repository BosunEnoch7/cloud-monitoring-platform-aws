# Prometheus

Contains the Prometheus scrape configuration and recording rules.

## Scrape Targets

- Prometheus self-monitoring on port `9090`
- Node Exporter host metrics on the private Compose network
- cAdvisor container metrics on the private Compose network

Prometheus retains up to seven days or 2 GB of metrics, whichever limit is
reached first. Alert rules cover target availability, rule failures, CPU,
memory, and filesystem capacity.

Run `scripts/validate-monitoring.sh` from a Linux host with Docker installed to
validate the Compose and Prometheus configuration.
