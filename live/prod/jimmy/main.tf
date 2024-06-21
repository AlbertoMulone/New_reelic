locals {
  common = yamldecode(file("../common.yaml"))
}

module "jimmy_infocert" {
  source       = "../../../modules/jimmy"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_APM_duration_check = true
  //duration_thresh_crt       = 10
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
      url               = "https://jimmy.printbc.infocert.it/actuator/health"
      url_num           = 1
      label             = "Health Check - printbc"
      validation_string = "\"status\":\"UP\","
      tech_serv         = "ST TRISS SSA"
      private           = true
      private_dc        = true
    }
  }
}

module "jimmyq_infocert" {
  source       = "../../../modules/jimmy"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"
  basename     = "jimmyq"

  enable_APM_duration_check = true
  //duration_thresh_crt       = 10
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
      url               = "https://jimmyq.printbc.infocert.it/actuator/health"
      url_num           = 1
      label             = "Health Check - printbc"
      validation_string = "\"status\":\"UP\","
      tech_serv         = "ST TRISSQ"
      private           = true
      private_dc        = true
    }
  }
}