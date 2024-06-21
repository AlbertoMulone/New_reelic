locals {
  common = yamldecode(file("../common.yaml"))
}

module "triss_infocert" {
  source       = "../../../modules/triss"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"
}
