locals {
  common = yamldecode(file("../common.yaml"))
}

module "roll_infocert" {
  source       = "../../../modules/roll"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  health_th_duration        = 300
  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://roll.infocert.it/actuator/health/ready"
      url_num           = 1
      label             = "Health Check - printbc"
      validation_string = "\"status\":\"UP\","
      tech_serv         = "ST InfoCert Sign Server"
      private           = true
      private_dc        = true
    }
  }
}

module "rollq_infocert" {
  source       = "../../../modules/roll"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"
  basename     = "rollq"

  health_th_duration        = 300
  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://rollq.printbc.infocert.it/actuator/health/ready"
      url_num           = 1
      label             = "Health Check - printbc"
      validation_string = "\"status\":\"UP\","
      tech_serv         = "ST TRISSQ"
      private           = true
      private_dc        = true
    }
  }
}