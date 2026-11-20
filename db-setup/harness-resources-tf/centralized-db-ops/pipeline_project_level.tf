resource "harness_platform_pipeline" "flyway" {
  org_id     = var.org_id
  project_id = var.project_id
  identifier = local.pipeline.identifier
  name       = local.pipeline.name
  tags       = [for key, value in try(local.pipeline.tags, {}) : "${key}:${value}"]

  yaml = local.pipeline_yaml

  git_details {
    store_type = "INLINE"
  }

  depends_on = [harness_platform_template.stage, harness_platform_db_instance.flyway]
}
