variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "Project name cannot be empty."
  }
}

variable "environment" {
  description = "Deployment environment name."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  description = "AWS region used to download the regional CloudWatch Agent package."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the monitoring host will run."
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet where the monitoring host will run."
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile attached to the monitoring host."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the monitoring host."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Optional existing EC2 key pair name for SSH access."
  type        = string
  default     = null
}

variable "enable_ssh" {
  description = "Whether to create an SSH ingress rule. Prefer SSM Session Manager."
  type        = bool
  default     = false
}

variable "admin_access_cidr" {
  description = "CIDR block allowed to access SSH. Override this with your public IP /32 before applying."
  type        = string
  default     = "203.0.113.10/32"

  validation {
    condition     = can(cidrhost(var.admin_access_cidr, 0))
    error_message = "Admin access CIDR must be a valid IPv4 CIDR block."
  }
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 12

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 30
    error_message = "Root volume size must be between 8 and 30 GiB for this dev environment."
  }
}

variable "tags" {
  description = "Additional tags applied to compute resources."
  type        = map(string)
  default     = {}
}
