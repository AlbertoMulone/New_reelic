locals {
  common = yamldecode(file("../common.yaml"))
}

module "atum" {
  source                    = "../../../modules/atum"
  env                       = local.common.env
  network_envs              = local.common.network_envs
  enabled                   = local.common.enabled
  notification              = local.common.notification
  env_newrelic              = "claws"
  clusterName               = "CL-EKS-lcert"
  deploymentName            = "atum-cl-deploy"

  enable_APM_duration_check = true
  duration_thresh_crt       = 10
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://atumcl.eu-south-1.clawsbc.infocert.it/atum/health"
      url_num           = 1
      label             = "Health Check - claws"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST-ATUM"
      private           = true
      private_dc        = true
    }
  }
}
