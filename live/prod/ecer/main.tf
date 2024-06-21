locals {
  common = yamldecode(file("../common.yaml"))
}

module "ecer_infocert" {
  source = "../../../modules/ecer"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification

  ecer_webservice = "https://ecer.infocert.it/ecer-webservice/"
}
