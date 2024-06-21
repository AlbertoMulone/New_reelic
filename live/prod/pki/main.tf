locals {
  common = yamldecode(file("../common.yaml"))
}

module "pki_infocert_it" {
  source = "../../../modules/pki"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification

  urls = {
    "ICERT_INDI_MO" = "https://pki.infocert.it/pdf/ICERT_INDI_MO.pdf"
  }
  
}
