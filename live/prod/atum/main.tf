locals {
  common = yamldecode(file("../common.yaml"))
}

module "atum" {
  source       = "../../../modules/atum"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  env_newrelic = "praws"
  clusterName               = "PR-Legalcert-EKS-Cluster"
  deploymentName            = "atum-pr-deploy"

  enable_APM_duration_check = true
  duration_thresh_crt       = 10
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://atumpr.eu-south-1.prawsbc.infocert.it/atum/health"
      url_num           = 1
      label             = "Health Check - praws"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST-ATUM"
      private           = true
      private_dc        = true
    }
  }
}
