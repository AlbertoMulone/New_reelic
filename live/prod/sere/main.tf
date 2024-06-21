locals {
  common = yamldecode(file("../common.yaml"))
}

module "sere" {
  source = "../../../modules/sere"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification

  url = "https://sere.print.infocert.it/sere-rest/sere-admin/welcome"
  
}
