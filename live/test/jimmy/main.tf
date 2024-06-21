locals {
  common = yamldecode(file("../common.yaml"))
}

module "jimmy_infocert" {
  source       = "../../../modules/jimmy"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"
}
