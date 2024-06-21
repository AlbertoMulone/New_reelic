locals {
  common = yamldecode(file("../common.yaml"))
}

module "idts" {
  source       = "../../../modules/idts"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"
  service_name = "idts"
  enable_probe = true

  enable_nagios = true

  app_name                  = "idts_prod"
  enable_APM_duration_check = true
  duration_thresh_crt       = 10
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  failure_thresh_duration   = 1200
  failure_aggr_method       = "event_flow"
  failure_aggr_delay        = 30
  failure_aggr_timer        = null

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://digitaltimestamp.print.infocert.it/idts-rest/dts/welcome"
      url_num           = 1
      label             = "IDTS Welcome Service"
      validation_string = "IDTS-REST welcome"
      tech_serv         = "ST Marcatura Temporale"
      private           = true
      private_dc        = true
    }
  }
}

module "idts_ifc" {
  source       = "../../../modules/idts"
  env          = local.common.env
  network_envs = local.common.network_envs_ifc
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocamere"
  service_name = "idtsifc"
  enable_probe = true

  app_name = "idts_ifc_prod"
}