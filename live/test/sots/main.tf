locals {
  common = yamldecode(file("../common.yaml"))
}

module "sots" {
  source       = "../../../modules/sots"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = true
  notification = local.common.notification
  service_name = "sots"
}
