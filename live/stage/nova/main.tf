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
  duration_thresh_crt       = 10
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://nova.clintbc.infocert.it/health/ready"
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

module "nova_aws_infocert" {
  source       = "../../../modules/nova-aws"
  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  namespaceName  = "lcert-ra2mi-svts-platform-namespace"
  deploymentName = "nova"

  enable_APM_duration_check = true
  duration_thresh_crt       = 10
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      # FIXME: hostname is going to change
      url               = "https://nova.eu-south-1.tsaws.infocert.it/health/ready"
      url_num           = 1
      product           = "NOVA ISP"
      label             = "Health Check - clawsbc"
      validation_string = "\"status\": \"UP\","
      tech_serv         = "ST Registration Authority 2"
      private           = true
      private_dc        = true
    }
  }
}