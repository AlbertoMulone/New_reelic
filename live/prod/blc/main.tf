locals {
  common = yamldecode(file("../common.yaml"))
}

module "blc" {
  source       = "../../../modules/blc"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = "legalcert_ticket"
  label        = "infocert"
  service_name = "blc"
}
