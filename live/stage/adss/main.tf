locals {
  common = yamldecode(file("../common.yaml"))
}

module "ocsp_adss_ii_aws" {
  source = "../../../modules/adss"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "isp identrust"
  service_name = "adssii"
}
