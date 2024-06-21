locals {
  common = yamldecode(file("../common.yaml"))
}

module "vaga" {
  source                    = "../../../modules/vaga"
  env                       = local.common.env
  network_envs              = local.common.network_envs
  enabled                   = local.common.enabled
  notification              = local.common.notification
  env_newrelic              = "praws"
  clusterName               = "PR-Legalcert-EKS-Cluster"
  deploymentName            = "vaga-pr-deploy"

  enable_APM_duration_check = true
  duration_thresh_crt       = 30
  duration_aggregation_delay  = 60
  duration_aggregation_window = 600
  enable_APM_db_check       = true
  db_resp_time_thresh       = 100
  db_type                   = "HSQLDB"
  db_transaction_type       = "operation"
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  failure_slide_by          = 30

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://api.infocert.digital/validation/signature/v2/info"
      url_num           = 1
      label             = "Health Check v2 - praws"
      validation_string = "lcert-sigval-vaga"
      tech_serv         = "sigval"
    }
    2 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://api.infocert.digital/validation/signature/v3/info"
      url_num           = 1
      label             = "Health Check v3 - praws"
      validation_string = "lcert-sigval-vaga"
      tech_serv         = "sigval"
    }
  }
}
