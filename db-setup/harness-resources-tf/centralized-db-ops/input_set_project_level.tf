locals {
  input_set_name = coalesce(var.pipeline_input_set.name, var.pipeline_input_set.identifier)
  input_set_values = {
    dbSchema                = var.pipeline_input_set.db_schema
    databaseInstanceList    = join(",", var.pipeline_input_set.database_instance_ids)
    maxMatrixConcurrency    = var.pipeline_input_set.max_matrix_concurrency
    kubernetesConnectorRef  = var.pipeline_input_set.kubernetes_connector_ref
    dockerImageConnectorRef = var.pipeline_input_set.docker_image_connector_ref
    enableBaseline          = tostring(var.pipeline_input_set.enable_baseline)
    enableManualApproval    = tostring(var.pipeline_input_set.enable_manual_approval)
  }
}

resource "harness_platform_input_set" "flyway" {
  identifier  = var.pipeline_input_set.identifier
  name        = local.input_set_name
  org_id      = var.org_id
  project_id  = var.project_id
  pipeline_id = harness_platform_pipeline.flyway.identifier

  yaml = yamlencode({
    inputSet = {
      name              = local.input_set_name
      tags              = {}
      identifier        = var.pipeline_input_set.identifier
      orgIdentifier     = var.org_id
      projectIdentifier = var.project_id
      pipeline = {
        identifier = harness_platform_pipeline.flyway.identifier
        variables = [
          for name, value in local.input_set_values : {
            name  = name
            type  = name == "maxMatrixConcurrency" ? "Number" : "String"
            value = value
          }
        ]
      }
    }
  })

  git_details {
    store_type = "INLINE"
  }
}
