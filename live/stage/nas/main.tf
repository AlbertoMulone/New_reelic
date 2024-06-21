locals {
  common = yamldecode(file("../common.yaml"))
}

module "nas" {
  source = "../../../modules/nas"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
}