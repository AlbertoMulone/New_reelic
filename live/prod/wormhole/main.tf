locals {
  common = yamldecode(file("../common.yaml"))
}

module "wormhole_infocert" {
  source       = "../../../modules/wormhole"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://wormhole.printbc.infocert.it/health/ready"
      url_num           = 1
      label             = "Health Check - printbc"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST PKI INTESA FD 2"
      private           = true
      private_dc        = true
    }
  }
}
