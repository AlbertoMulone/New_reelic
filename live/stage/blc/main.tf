locals {
  common = yamldecode(file("../common.yaml"))
}

module "blc" {
  source       = "../../../modules/blc"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"
  service_name = "blc"
}
