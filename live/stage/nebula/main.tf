locals {
  common = yamldecode(file("../common.yaml"))
}

module "nebula_infocert" {
  source       = "../../../modules/nebula"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
}

module "nebula_aws_infocert" {
  source       = "../../../modules/nebula-aws"
  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  namespaceName  = "lcert-ra2mi-cl-platform-namespace"
  deploymentName = "nebula"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
}