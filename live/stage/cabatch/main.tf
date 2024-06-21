locals {
  common = yamldecode(file("../common.yaml"))
}

module "cabatch" {
  source = "../../../modules/cabatch"

  env          = local.common.env
  network_envs = local.common.network_envs
  #enabled      = local.common.enabled
  enabled      = false
  notification = local.common.notification
  label        = "infocert"
  service_name = "cabatch"
}
