locals {
  common = yamldecode(file("../common.yaml"))
}

module "cara" {
  source = "../../../modules/cara"

  env           = local.common.env
  network_envs  = local.common.network_envs
  enabled       = local.common.enabled
  notification  = "legalcert_ticket"
  enable_checks = true

  db_monitor_info = {
    "CDCR" = {
      product      = "CARA"
      service_name = "CDCR"
      thresh_crt   = 10000
      thresh_wrn   = 20000
    }
    "NCFR" = {
      product      = "CARA"
      service_name = "NCFR"
      thresh_crt   = 10000
      thresh_wrn   = 20000
    }
    "SEQUENCE" = {
      product      = "CARA"
      service_name = "SEQUENCE"
      thresh_crt   = 200000
      thresh_wrn   = 300000
    }
  }
}
