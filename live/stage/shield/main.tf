locals {
  common = yamldecode(file("../common.yaml"))
}

module "shield_infocert" {
  source       = "../../../modules/shield"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
}

module "shield_aws_infocert" {
  source       = "../../../modules/shield-aws"
  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  namespaceName             = "lcert-trissq-cl-platform-namespace"
  deploymentName            = "shield"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
}


module "shieldq_infocert" {
  source       = "../../../modules/shield"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"
  basename     = "shieldq"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
}