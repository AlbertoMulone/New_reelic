locals {
  common = yamldecode(file("../common.yaml"))
}

module "deck_infocert" {
  source       = "../../../modules/deck"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  enable_probe              = true
}
