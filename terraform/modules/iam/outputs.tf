output "ec2_role_name" {
  description = "Name of the EC2 monitoring IAM role."
  value       = aws_iam_role.ec2_monitoring.name
}

output "ec2_role_arn" {
  description = "ARN of the EC2 monitoring IAM role."
  value       = aws_iam_role.ec2_monitoring.arn
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile for the EC2 monitoring host."
  value       = aws_iam_instance_profile.ec2_monitoring.name
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile for the EC2 monitoring host."
  value       = aws_iam_instance_profile.ec2_monitoring.arn
}
