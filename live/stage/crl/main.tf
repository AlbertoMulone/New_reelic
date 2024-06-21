locals {
  common = yamldecode(file("../common.yaml"))
}

module "crl" {
  source = "../../../modules/crl"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  crl_info = [
    "InfoCertCA2Coll",
    "InfoCertCA3Coll",
    "InfoCertCA4Coll",
    "IntesaSanpaoloColl",
    "IntesaSanpaoloFQ2Coll",
    "SogeiCNSColl",
    "ZucchettiColl",
    "ZucchettiCA2Coll",
    "CamerfirmaColl"
  ]
}
