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

  app_name = "idts_coll"
  enable_APM_duration_check = true
  duration_thresh_crt       = 10
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  failure_aggr_method       = "event_timer"
  failure_aggr_timer        = 60
  failure_slide_by          = 30

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://digitaltimestamp.clint.infocert.it/idts-rest/dts/welcome"
      url_num           = 1
      label             = "IDTS Welcome Service"
      validation_string = "IDTS-REST welcome"
      tech_serv         = "ST Marcatura Temporale"
      private           = true
      private_dc        = true
    }
  }
}
