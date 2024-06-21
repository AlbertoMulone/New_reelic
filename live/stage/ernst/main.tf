locals {
  common = yamldecode(file("../common.yaml"))
}

module "ernst_infocert" {
  source       = "../../../modules/ernst"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  failure_slide_by          = 30
  #enable_APM_apdex_check    = true
  #apdex_thresh_check        = 0.75

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ernst.clintbc.infocert.it/health/ready"
      url_num           = 1
      label             = "Health Check"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST Registration Authority 2"
      private           = true
      private_dc        = true
    }
  }
}

module "ernst_aws_infocert" {
  source       = "../../../modules/ernst-aws"
  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  namespaceName  = "lcert-ra2mi-cl-platform-namespace"
  deploymentName = "ernst"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  failure_slide_by          = 30

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      # FIXME: hostname is going to change
      url               = "https://ernst.eu-south-1.claws.infocert.it/health/ready"
      url_num           = 1
      label             = "Health Check"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST Registration Authority 2"
      private           = true
      private_dc        = true
    }
  }
}
