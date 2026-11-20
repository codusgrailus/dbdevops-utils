terraform {
  required_version = ">= 1.6.0"

  required_providers {
    harness = {
      source  = "harness/harness"
      version = "~> 0.47.8"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "harness" {}

locals {
  templates_by_file = {
    for filename in var.template_yaml_files_list :
    filename => yamldecode(data.external.generated_yaml.result[filename]).template
  }

  pipeline_yaml = data.external.generated_yaml.result[var.pipeline_yaml_file]
  pipeline      = yamldecode(local.pipeline_yaml).pipeline
}
