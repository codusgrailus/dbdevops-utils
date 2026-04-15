output "aurora_cluster_endpoint" {
  description = "Writer endpoint for the Aurora cluster"
  value       = aws_rds_cluster.aurora.endpoint
}

output "aurora_reader_endpoint" {
  description = "Reader endpoint for the Aurora cluster"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "aurora_port" {
  value = aws_rds_cluster.aurora.port
}

output "aurora_db_name" {
  value = aws_rds_cluster.aurora.database_name
}

output "aurora_admin_username" {
  value = aws_rds_cluster.aurora.master_username
}

output "aurora_cluster_id" {
  value = aws_rds_cluster.aurora.cluster_identifier
}

output "aurora_engine_version" {
  value = aws_rds_cluster.aurora.engine_version_actual
}
