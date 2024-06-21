locals {
  common = yamldecode(file("../common.yaml"))
}

module "roll_infocert" {
  source       = "../../../modules/roll"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  health_th_duration        = 300
}

module "roll_aws_infocert" {
  source       = "../../../modules/roll-aws"
  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  namespaceName             = "lcert-trissq-cl-platform-namespace"
  deploymentName            = "roll"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
}

module "rollq_infocert" {
  source       = "../../../modules/roll"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = false
  notification = local.common.notification
  basename     = "rollq"
  label        = "infocert"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  health_th_duration        = 300
}