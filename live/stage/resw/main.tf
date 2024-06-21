locals {
  common = yamldecode(file("../common.yaml"))
}

module "resw_infocert" {
  source       = "../../../modules/resw"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://resw.clint.infocert.it/resw-intra-api/welcome"
      url_num           = 1
      label             = "Welcome Service"
      validation_string = "Welcome to RESW"
      tech_serv         = "ST Registration Authority"
      private           = true
      private_dc        = true
    }
  }
}
