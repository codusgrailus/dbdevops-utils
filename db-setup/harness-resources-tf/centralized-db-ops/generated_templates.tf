data "external" "generated_yaml" {
  program = [
    "python3",
    abspath(var.template_generator_path),
    "-org_id", var.org_id,
    "-proj_id", var.project_id,
    "--json",
  ]
}

resource "local_file" "generated_yaml" {
  for_each = data.external.generated_yaml.result

  filename             = "${path.module}/.generated_templates/${each.key}"
  content              = each.value
  file_permission      = "0644"
  directory_permission = "0755"
}
