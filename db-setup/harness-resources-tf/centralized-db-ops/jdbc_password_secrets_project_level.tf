resource "harness_platform_secret_text" "jdbc_password" {
  for_each = toset([for connector in values(var.jdbc_connectors) : connector.password_ref])

  org_id                    = var.org_id
  project_id                = var.project_id
  identifier                = each.key
  name                      = each.key
  secret_manager_identifier = "harnessSecretManager"
  value_type                = "Inline"
  value                     = lookup(var.jdbc_passwords, each.key, null)

  lifecycle {
    precondition {
      condition     = try(length(var.jdbc_passwords[each.key]) > 0, false)
      error_message = "Provide a non-empty JDBC password for secret ${each.key} in jdbc_passwords."
    }
  }
}
