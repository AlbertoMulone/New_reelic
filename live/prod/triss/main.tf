locals {
  common = yamldecode(file("../common.yaml"))
}

module "triss_infocert" {
  source       = "../../../modules/triss"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  enable_APM_db_check       = true
  db_resp_time_thresh       = 100
  db_type                   = "MongoDB"
  db_transaction_type       = "operation"

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "http://triss.printbc.ca.infocert.it/health/ready"
      url_num           = 1
      verify_ssl        = false
      label             = "Health Check - prdmzbc.ca"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST TRISS"
      private           = true
    }
  }
}
