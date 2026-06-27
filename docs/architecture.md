# Architecture

## System View

```mermaid
flowchart TB
  developer[Developer] --> github[GitHub repository]
  github --> actions[GitHub Actions validation]
  actions --> terraform[Terraform modules]

  subgraph aws[AWS account]
    subgraph vpc[VPC]
      subnet[Public subnet]
      sg[Security group: no default ingress]

      subgraph ec2[Ubuntu EC2 monitoring host]
        ssm[SSM Agent]
        cwagent[CloudWatch Agent]

        subgraph compose[Docker Compose network]
          prometheus[Prometheus]
          node[Node Exporter]
          cadvisor[cAdvisor]
          grafana[Grafana]
          alertmanager[Alertmanager]
        end
      end
    end

    logs[CloudWatch Logs]
    alarms[CloudWatch Alarms]
    sns[Encrypted SNS topic]
  end

  terraform --> vpc
  subnet --> sg --> ec2
  developer -. SSM port forwarding .-> ssm
  node --> prometheus
  cadvisor --> prometheus
  prometheus --> grafana
  prometheus --> alertmanager
  cwagent --> logs
  ec2 --> alarms --> sns
  alertmanager --> slack[Slack]
```

The editable Mermaid source is in `architecture/platform.mmd`.

## Data Flows

1. Node Exporter exposes Ubuntu host metrics to Prometheus.
2. cAdvisor exposes Docker container metrics to Prometheus.
3. Grafana queries Prometheus over the private Compose network.
4. Prometheus sends firing and resolved alerts to Alertmanager.
5. Alertmanager groups, inhibits, and sends notifications to Slack.
6. CloudWatch Agent forwards system, bootstrap, and Docker logs.
7. Native EC2 alarms notify an encrypted SNS topic.

## Module Boundaries

| Module | Ownership |
| --- | --- |
| `network` | VPC, subnet, internet gateway, route table |
| `compute` | Security group, Ubuntu EC2, encrypted EBS, bootstrap |
| `iam` | EC2 role, SSM access, scoped CloudWatch Logs access |
| `cloudwatch` | Log groups, retention, alarms, SNS |

## Design Decisions

- One EC2 host keeps the portfolio environment inexpensive and understandable.
- Terraform modules separate ownership without hiding a small design behind too
  many abstractions.
- SSM replaces default inbound administration and provides encrypted tunnels.
- Prometheus and CloudWatch overlap intentionally: Prometheus handles detailed
  workload telemetry; CloudWatch provides AWS-native logs and instance alarms.
- Configurations and dashboards are provisioned from Git rather than edited
  manually in web interfaces.

## Production Tradeoffs

This is production-inspired, not a highly available production platform. A
larger deployment would use private subnets, multiple instances or a managed
container platform, remote Terraform state, durable external metrics storage,
HTTPS ingress, centralized secrets, and tested backup/restore procedures.
