locals {
  name_prefix = "${var.project_name}-${var.environment}"
  cloudwatch_agent_config = templatefile(
    "${path.module}/templates/amazon-cloudwatch-agent.json.tftpl",
    {
      project_name = var.project_name
      environment  = var.environment
    }
  )

  common_tags = merge(
    var.tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "compute"
    }
  )
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "monitoring_host" {
  name        = "${local.name_prefix}-monitoring-sg"
  description = "Controls access to the EC2 monitoring host."
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-monitoring-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  count = var.enable_ssh ? 1 : 0

  security_group_id = aws_security_group.monitoring_host.id
  description       = "SSH access from an approved administrator CIDR."
  cidr_ipv4         = var.admin_access_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.monitoring_host.id
  description       = "Allow outbound internet access for package updates and monitoring integrations."
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "monitoring_host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.monitoring_host.id]
  iam_instance_profile        = var.iam_instance_profile_name
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data = templatefile(
    "${path.module}/templates/bootstrap.sh.tftpl",
    {
      aws_region              = var.aws_region
      cloudwatch_agent_config = local.cloudwatch_agent_config
    }
  )
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-monitoring-host"
      Role = "monitoring"
    }
  )
}
