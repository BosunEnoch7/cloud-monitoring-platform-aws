output "instance_id" {
  description = "ID of the EC2 monitoring host."
  value       = aws_instance.monitoring_host.id
}

output "instance_arn" {
  description = "ARN of the EC2 monitoring host."
  value       = aws_instance.monitoring_host.arn
}

output "public_ip" {
  description = "Public IP address of the EC2 monitoring host."
  value       = aws_instance.monitoring_host.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 monitoring host."
  value       = aws_instance.monitoring_host.public_dns
}

output "security_group_id" {
  description = "ID of the monitoring host security group."
  value       = aws_security_group.monitoring_host.id
}

output "ubuntu_ami_id" {
  description = "Ubuntu AMI ID selected for the monitoring host."
  value       = data.aws_ami.ubuntu.id
}
