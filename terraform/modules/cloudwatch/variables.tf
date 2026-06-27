variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "ec2_instance_id" {
  description = "ID of the EC2 monitoring host observed by CloudWatch alarms."
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period."
  type        = number
  default     = 7

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90], var.log_retention_days)
    error_message = "Log retention must be a supported cost-controlled value."
  }
}

variable "alert_email" {
  description = "Optional email endpoint for SNS alerts. AWS requires subscription confirmation."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.alert_email == null || can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alert_email))
    error_message = "Alert email must be null or a valid email address."
  }
}

variable "tags" {
  description = "Additional tags applied to CloudWatch and SNS resources."
  type        = map(string)
  default     = {}
}
