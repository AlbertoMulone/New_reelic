terragrunt_version_constraint = "= 0.45.18"

locals {
  provider = yamldecode(file(find_in_parent_folders("provider.yaml")))
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "${local.provider.terraform.version}"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "${local.provider.newrelic.version}"
    }
  }
}

provider "newrelic" {
  region = "${local.provider.newrelic.region}"
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket                  = "lcert-pr-aws-newrelic-state"
    dynamodb_table          = "lcert-pr-aws-newrelic-lock"
    region                  = "eu-south-1"
    encrypt                 = true
    key                     = "${path_relative_to_include()}/terraform.tfstate"
  }
}
