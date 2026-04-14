variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_name" {
  type    = string
  default = "mysql8-test"
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "mysql_admin_username" {
  type    = string
  default = "mysqluser02"
}

variable "mysqluser02_password" {
  type      = string
  sensitive = true
}
