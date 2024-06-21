locals {
  common = yamldecode(file("../common.yaml"))
}

module "bridge" {
  source              = "../../../modules/bridge"
  env                 = local.common.env
  network_envs        = local.common.network_envs
  enabled             = local.common.enabled
  notification        = local.common.notification
  enable_probe        = true
}