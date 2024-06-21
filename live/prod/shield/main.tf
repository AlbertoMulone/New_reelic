locals {
  common = yamldecode(file("../common.yaml"))
}

module "shield_infocert" {
  source       = "../../../modules/shield"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  
  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://shield.infocert.it/actuator/health/ready"
      url_num           = 1
      label             = "Health Check - printbc"
      validation_string = "\"status\":\"UP\","
      tech_serv         = "ST TRISS SSA"
      private           = true
      private_dc        = true
    }
  }
}

module "shieldq_infocert" {
  source       = "../../../modules/shield"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"
  basename     = "shieldq"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  failure_aggr_window       = 600
  failure_slide_by          = 60

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://shieldq.printbc.infocert.it/actuator/health/ready"
      url_num           = 1
      label             = "Health Check - printbc"
      validation_string = "\"status\":\"UP\","
      tech_serv         = "ST TRISSQ"
      private           = true
      private_dc        = true
    }
  }
}
