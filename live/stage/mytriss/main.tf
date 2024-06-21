locals {
  common = yamldecode(file("../common.yaml"))
}

module "mytriss_infocert" {
  source        = "../../../modules/mytriss"
  env           = local.common.env
  network_envs  = local.common.network_envs
  enabled       = local.common.enabled
  notification  = local.common.notification
  label         = "infocert"
  new_relic_env = "clint"

  enable_APM_duration_check = true
  duration_thresh_crt       = 10
  enable_APM_apdex_check    = true
  apdex_thresh_check        = 0.5

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://mytriss.clint.infocert.it/health/ready"
      url_num           = 1
      label             = "Health Check"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST-TRISS-SSA"
      private           = true
      private_dc        = true
    }
  }
}
