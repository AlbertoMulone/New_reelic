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
    "CNDCEC3",
    "InfoCertCA2",
    "InfoCertCA2TOT",
    "InfoCertCA3",
    "InfoCertCA4",
    "IntesaSanpaoloFQ",
    "IntesaSanpaoloFQ_AWS",
    "IntesaSanpaoloFQ2",
    "IntesaSanpaololdenTrust",
    "IntesaSanpaololdenTrust_AWS",
    "SogeiCNS",
    "Zucchetti",
    "ZucchettiCA2",
    "Camerfirma",
    "InfoCamere"
  ]
}
