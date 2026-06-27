output "vpc_id" {
  description = "ID of the dev VPC."
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID of the dev public subnet."
  value       = module.network.public_subnet_id
}

output "public_route_table_id" {
  description = "ID of the dev public route table."
  value       = module.network.public_route_table_id
}

output "internet_gateway_id" {
  description = "ID of the dev internet gateway."
  value       = module.network.internet_gateway_id
}

output "ec2_instance_id" {
  description = "ID of the EC2 monitoring host."
  value       = module.compute.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 monitoring host."
  value       = module.compute.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the EC2 monitoring host."
  value       = module.compute.public_dns
}

output "monitoring_security_group_id" {
  description = "ID of the monitoring host security group."
  value       = module.compute.security_group_id
}

output "ec2_iam_role_name" {
  description = "Name of the EC2 monitoring IAM role."
  value       = module.iam.ec2_role_name
}

output "cloudwatch_log_group_names" {
  description = "CloudWatch log groups used by the monitoring host."
  value       = module.cloudwatch.log_group_names
}

output "platform_alerts_sns_topic_arn" {
  description = "ARN of the SNS topic receiving CloudWatch alarms."
  value       = module.cloudwatch.sns_topic_arn
}
