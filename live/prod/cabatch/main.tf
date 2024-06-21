locals {
  common = yamldecode(file("../common.yaml"))
}

module "cabatch" {
  source = "../../../modules/cabatch"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = "legalcert_ticket"
  label        = "infocert"
  service_name = "cabatch"
}

module "cabatch_ifc" {
  source = "../../../modules/cabatch"

  env          = local.common.env
  network_envs = local.common.network_envs_ifc
  enabled      = local.common.enabled
  notification = "legalcert_ticket"
  label        = "infocamere"
  service_name = "cabatchifc"
}
