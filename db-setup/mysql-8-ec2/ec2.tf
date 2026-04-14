terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "ssh" {
  key_name   = "${var.instance_name}-ssh"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_sensitive_file" "ssh_private_key" {
  filename        = "${path.module}/${var.instance_name}-ssh.pem"
  content         = tls_private_key.ssh.private_key_openssh
  file_permission = "0600"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "mysql" {
  name        = var.instance_name
  description = "MySQL 8 test instance security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "MySQL from anywhere (testing only)"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere (testing only)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "mysql" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids      = [aws_security_group.mysql.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.ssh.key_name

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    mysql_admin_username = var.mysql_admin_username
    mysql_user_password = var.mysqluser02_password
  })

  depends_on = [local_sensitive_file.ssh_private_key]

  tags = {
    Name = var.instance_name
  }
}
