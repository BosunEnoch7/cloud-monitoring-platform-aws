variable "aws_region" {
  description = "AWS region used for the dev environment."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
  default     = "cloud-monitoring-platform-aws"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the dev VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the dev public subnet."
  type        = string
  default     = "10.10.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for the dev public subnet."
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type for the monitoring host."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Optional existing EC2 key pair name for SSH access."
  type        = string
  default     = null
}

variable "enable_ssh" {
  description = "Whether to permit SSH from admin_access_cidr."
  type        = bool
  default     = false
}

variable "admin_access_cidr" {
  description = "CIDR allowed to access SSH when enable_ssh is true."
  type        = string
  default     = "203.0.113.10/32"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 12
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period for the dev environment."
  type        = number
  default     = 7
}

variable "alert_email" {
  description = "Optional email address subscribed to the SNS platform alerts topic."
  type        = string
  default     = null
  nullable    = true
}
