variable "org_id" {
  type        = string
  description = "Existing Harness organization that owns the stage templates and the target project."
}

variable "project_id" {
  type        = string
  description = "Existing Harness project that owns the DB schema, DB instances, and pipeline."
}

variable "template_generator_path" {
  type        = string
  nullable    = false
  description = "Absolute path or path relative to the Terraform working directory for the Python YAML generator."

  validation {
    condition     = try(fileexists(var.template_generator_path), false)
    error_message = "Set template_generator_path to an existing Python generator file."
  }
}

variable "template_yaml_files_list" {
  type        = list(string)
  nullable    = false
  description = "Stage template YAML filenames in the module's .generated_templates directory."

  validation {
    condition = (
      length(var.template_yaml_files_list) > 0 &&
      length(distinct(var.template_yaml_files_list)) == length(var.template_yaml_files_list) &&
      alltrue([for filename in var.template_yaml_files_list : basename(filename) == filename && endswith(filename, ".yaml")])
    )
    error_message = "Provide unique stage template .yaml filenames without directory paths."
  }
}

variable "pipeline_yaml_file" {
  type        = string
  nullable    = false
  description = "Pipeline YAML filename in the module's .generated_templates directory."

  validation {
    condition     = basename(var.pipeline_yaml_file) == var.pipeline_yaml_file && endswith(var.pipeline_yaml_file, ".yaml")
    error_message = "Provide a pipeline .yaml filename without a directory path."
  }
}

variable "pipeline_input_set" {
  description = "Project-level input set and runtime values for the Flyway pipeline."
  nullable    = false
  type = object({
    identifier                 = string
    name                       = optional(string)
    db_schema                  = string
    database_instance_ids      = list(string)
    max_matrix_concurrency     = number
    kubernetes_connector_ref   = string
    docker_image_connector_ref = string
    enable_baseline            = bool
    enable_manual_approval     = bool
  })
}

variable "db_schema" {
  description = "Flyway schema identity and source paths relative to the migration repository."
  type = object({
    identifier        = string
    name              = optional(string)
    git_connector_ref = optional(string)
    repository        = string
    migrations_path   = string
    toml_path         = string
  })
}

variable "jdbc_passwords" {
  type        = map(string)
  sensitive   = true
  nullable    = false
  description = "JDBC password values keyed by their project-level Harness secret identifiers."
}

variable "jdbc_connectors" {
  description = "Project JDBC connectors keyed by Harness connector identifier. password_ref is the identifier of a project secret created from jdbc_passwords."
  type = map(object({
    name               = optional(string)
    url                = string
    username           = optional(string)
    username_ref       = optional(string)
    password_ref       = string
    delegate_selectors = optional(set(string), [])
  }))

  validation {
    condition = alltrue([
      for connector in values(var.jdbc_connectors) :
      (try(trimspace(connector.username) != "", false) != try(trimspace(connector.username_ref) != "", false))
    ])
    error_message = "For each JDBC connector, provide exactly one of username or username_ref."
  }

  validation {
    condition = alltrue([
      for connector in values(var.jdbc_connectors) :
      can(regex("^[A-Za-z_][A-Za-z0-9_$]*$", connector.password_ref))
    ])
    error_message = "Use a project-level secret identifier without an org. or account. prefix for password_ref."
  }
}

variable "db_instances" {
  description = "Database instances keyed by Harness instance identifier. jdbc_connector_ref must match a key in jdbc_connectors."
  type = map(object({
    name               = optional(string)
    jdbc_connector_ref = string
    branch             = string
    tags               = optional(set(string), [])
  }))

  validation {
    condition     = length(var.db_instances) > 0
    error_message = "Provide at least one DB instance."
  }
}
