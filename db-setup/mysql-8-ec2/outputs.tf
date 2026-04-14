output "mysql_public_ip" {
  value = aws_instance.mysql.public_ip
}

output "mysql_public_dns" {
  value = aws_instance.mysql.public_dns
}

output "mysql_port" {
  value = 3306
}

output "mysql_user" {
  value = var.mysql_admin_username
}

output "ssh_private_key_path" {
  value = local_sensitive_file.ssh_private_key.filename
}

output "ssh_key_name" {
  value = aws_key_pair.ssh.key_name
}
