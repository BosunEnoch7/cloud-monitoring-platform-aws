# CloudWatch Module

Owns AWS-native logging, monitoring, and notification resources.

Resources:

- CloudWatch log groups for system, Docker, and bootstrap logs
- Cost-controlled log retention
- EC2 status-check and high-CPU alarms
- AWS-managed encrypted SNS topic
- Optional email subscription

Email subscriptions remain pending until the recipient confirms the message from
AWS. CloudWatch Logs ingestion, storage, alarms, and SNS delivery can incur
charges outside account allowances.
