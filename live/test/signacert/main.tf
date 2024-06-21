locals {
  common = yamldecode(file("../common.yaml"))
}

module "signacert_infocert_bc" {
  source = "../../../modules/signacert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert bc"
  service_name = "signabc"
}

module "signacert_infocert_ca3" {
  source = "../../../modules/signacert"

  env           = local.common.env
  network_envs  = local.common.network_envs
  enabled       = true
  notification  = local.common.notification
  label         = "infocert ca3"
  service_name  = "signa3ice"
  enable_nagios = true
}

module "signacert_infocert_ca4" {
  source = "../../../modules/signacert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert ca4"
  service_name = "signa4ice"
}
