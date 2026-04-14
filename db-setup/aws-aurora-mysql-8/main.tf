terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group" "aurora" {
  name        = "${var.cluster_name}-sg"
  description = "Aurora MySQL security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL from anywhere (testing only)"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.cluster_name}-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "${var.cluster_name}-subnet-group"
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = var.cluster_name
  engine                  = "aurora-mysql"
  engine_version          = var.mysql_engine_version
  database_name           = var.db_name
  master_username         = var.db_admin_username
  master_password         = var.db_admin_password
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  vpc_security_group_ids  = [aws_security_group.aurora.id]

  # Required for public accessibility
  network_type = "IPV4"

  skip_final_snapshot = true

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_rds_cluster_instance" "aurora" {
  count              = var.instance_count
  identifier         = "${var.cluster_name}-instance-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version

  db_subnet_group_name = aws_db_subnet_group.aurora.name

  publicly_accessible = var.publicly_accessible

  tags = {
    Name = "${var.cluster_name}-instance-${count.index + 1}"
  }
}
