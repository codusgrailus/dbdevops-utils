resource "harness_platform_template" "stage" {
  for_each = {
    for filename, template in local.templates_by_file :
    "${template.identifier}:${template.versionLabel}" => filename
  }

  org_id     = var.org_id
  identifier = local.templates_by_file[each.value].identifier
  name       = local.templates_by_file[each.value].name
  version    = local.templates_by_file[each.value].versionLabel
  tags       = [for key, value in try(local.templates_by_file[each.value].tags, {}) : "${key}:${value}"]

  template_yaml = data.external.generated_yaml.result[each.value]

  git_details {
    store_type = "INLINE"
  }
}
