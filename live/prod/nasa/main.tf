locals {
  common = yamldecode(file("../common.yaml"))
}

module "nasa_infocert" {
  source       = "../../../modules/nasa"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://nasa.printbc.infocert.it/health/ready"
      url_num           = 1
      label             = "Health Check - printbc"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST Verifica Revoche"
      private           = true
      private_dc        = true
    }
  }
}
