locals {
  common = yamldecode(file("../common.yaml"))
}

module "lcrs_infocert" {
  source       = "../../../modules/lcrs"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_APM_duration_check = true
  duration_thresh_crt       = 10
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://restcl.legalcert.infocert.it/lcrs-service/welcome/"
      url_num           = 1
      label             = "Welcome Service"
      validation_string = "Benvenuti in LCRS"
      tech_serv         = "ST Registration Authority"
    }
  }
}
