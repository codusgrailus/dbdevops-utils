resource "harness_platform_connector_jdbc" "flyway" {
  for_each = var.jdbc_connectors

  org_id             = var.org_id
  project_id         = var.project_id
  identifier         = each.key
  name               = coalesce(each.value.name, each.key)
  url                = each.value.url
  delegate_selectors = each.value.delegate_selectors

  credentials {
    auth_type = "UsernamePassword"

    username_password {
      username     = each.value.username
      username_ref = each.value.username_ref
      password_ref = harness_platform_secret_text.jdbc_password[each.value.password_ref].identifier
    }
  }
}
