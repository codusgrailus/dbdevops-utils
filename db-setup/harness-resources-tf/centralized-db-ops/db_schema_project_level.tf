resource "harness_platform_db_schema" "flyway" {
  org_id         = var.org_id
  project_id     = var.project_id
  identifier     = var.db_schema.identifier
  name           = coalesce(var.db_schema.name, var.db_schema.identifier)
  migration_type = "Flyway"
  type           = "Repository"

  schema_source {
    connector = var.db_schema.git_connector_ref
    repo      = var.db_schema.repository
    location  = var.db_schema.migrations_path
    toml      = var.db_schema.toml_path
  }
}
