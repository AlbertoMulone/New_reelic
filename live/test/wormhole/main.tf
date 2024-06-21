locals {
  common = yamldecode(file("../common.yaml"))
}

module "wormhole_infocert" {
  source       = "../../../modules/wormhole"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
}
