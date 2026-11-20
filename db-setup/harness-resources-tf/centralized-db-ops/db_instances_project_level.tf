resource "harness_platform_db_instance" "flyway" {
  for_each = var.db_instances

  org_id     = var.org_id
  project_id = var.project_id
  identifier = each.key
  name       = coalesce(each.value.name, each.key)
  schema     = harness_platform_db_schema.flyway.identifier
  connector  = harness_platform_connector_jdbc.flyway[each.value.jdbc_connector_ref].identifier
  branch     = each.value.branch
  tags       = each.value.tags
}
