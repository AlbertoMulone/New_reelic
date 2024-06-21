locals {
  common = yamldecode(file("../common.yaml"))
}

module "pulce" {
  source = "../../../modules/pulce"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification

  url = "https://pulce.print.infocert.it/pulce/welcome"
  
}
