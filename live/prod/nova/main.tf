locals {
  common = yamldecode(file("../common.yaml"))
}

module "nova_infocert" {
  source       = "../../../modules/nova"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_APM_duration_check = true
  enable_APM_db_check       = true
  db_resp_time_thresh       = 100
  db_type                   = "MongoDB"
  db_transaction_type       = "operation"
  enable_APM_apdex_check    = true
  apdex_thresh              = 0.75
  apdex_thresh_duration     = 480
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://nova.printbc.infocert.it/health/ready"
      url_num           = 1
      label             = "Health Check - printbc"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST Registration Authority 2"
      private           = true
      private_dc        = true
    }
  }
}

module "nova_isp" {
  source                    = "../../../modules/nova"
  env                       = local.common.env
  network_envs              = local.common.network_envs
  enabled                   = local.common.enabled
  notification              = local.common.notification
  label                     = "isp"
  enable_APM_duration_check = true
  enable_APM_db_check       = true
  db_resp_time_thresh       = 100
  db_type                   = "MongoDB"
  db_transaction_type       = "operation"
  enable_APM_apdex_check    = true
  apdex_thresh              = 0.75
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://novaisp.printbc.infocert.it/health/ready"
      url_num           = 1
      product           = "NOVA ISP"
      label             = "Health Check - printbc"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST Registration Authority 2"
      private           = true
      private_dc        = true
    }
  }
}
