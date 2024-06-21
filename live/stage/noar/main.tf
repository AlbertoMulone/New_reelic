locals {
  common = yamldecode(file("../common.yaml"))
}

module "noar_infocert" {
  source       = "../../../modules/noar"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://noar.clintbc.infocert.it/health/ready"
      url_num           = 1
      label             = "Health Check"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST Registration Authority 2"
      private           = true
      private_dc        = true
    }
  }
}
