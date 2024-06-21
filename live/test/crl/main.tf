locals {
  common = yamldecode(file("../common.yaml"))
}

module "crl" {
  source = "../../../modules/crl"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = true
  notification = local.common.notification
  crl_info = [
    "InfoCertCA4Test",
    "InfoCertCA3Test",
  ]
}
