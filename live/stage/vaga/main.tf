locals {
  common = yamldecode(file("../common.yaml"))
}

module "vaga" {
  source                    = "../../../modules/vaga"
  env                       = local.common.env
  network_envs              = local.common.network_envs
  enabled                   = local.common.enabled
  notification              = local.common.notification
  env_newrelic              = "claws"
  clusterName               = "CL-EKS-lcert"
  deploymentName            = "vaga-cl-deploy"

  enable_APM_duration_check = true
  duration_thresh_crt       = 10
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  failure_slide_by          = 30
  enable_APM_db_check       = true
  db_resp_time_thresh       = 100
  db_type                   = "HSQLDB"
  db_transaction_type       = "operation"

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://apistage.infocert.digital/validation/signature/v2/info"
      url_num           = 1
      label             = "Health Check v2 - claws"
      validation_string = "lcert-sigval-vaga"
      tech_serv         = "sigval"
    }
    2 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://apistage.infocert.digital/validation/signature/v3/info"
      url_num           = 1
      label             = "Health Check v3 - claws"
      validation_string = "lcert-sigval-vaga"
      tech_serv         = "sigval"
    }
  }
}
