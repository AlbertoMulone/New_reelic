locals {
  common = yamldecode(file("../common.yaml"))
}

module "parsec_infocert" {
  source       = "../../../modules/parsec"
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
      url               = "https://parsec.cldmzbc.ca.infocert.it/health/ready"
      url_num           = 1
      label             = "Health Check - cldmzbc.ca"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST Registration Authority 2"
      private           = true
    }
  }
}
