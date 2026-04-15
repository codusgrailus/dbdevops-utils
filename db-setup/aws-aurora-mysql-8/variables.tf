variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "cluster_name" {
  type    = string
  default = "aurora-mysql-test"
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "instance_count" {
  type    = number
  default = 1
  description = "Number of Aurora cluster instances (1 = writer only, 2+ = writer + reader(s))"
}

variable "mysql_engine_version" {
  type    = string
  default = "8.0.mysql_aurora.3.07.1"
}

variable "db_name" {
  type    = string
  default = "mydb"
}

variable "db_admin_username" {
  type    = string
  default = "auroraadmin"
}

variable "db_admin_password" {
  type      = string
  sensitive = true
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where Aurora will be deployed"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Set to true to assign a public IP to Aurora instances (testing only)"
}
