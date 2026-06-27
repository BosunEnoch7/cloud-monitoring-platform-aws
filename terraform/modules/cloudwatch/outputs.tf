output "log_group_names" {
  description = "CloudWatch log groups keyed by workload type."
  value       = { for key, log_group in aws_cloudwatch_log_group.this : key => log_group.name }
}

output "sns_topic_arn" {
  description = "ARN of the platform alerts SNS topic."
  value       = aws_sns_topic.platform_alerts.arn
}

output "cloudwatch_alarm_arns" {
  description = "ARNs of the EC2 CloudWatch alarms."
  value = [
    aws_cloudwatch_metric_alarm.instance_status_check_failed.arn,
    aws_cloudwatch_metric_alarm.high_cpu.arn
  ]
}
