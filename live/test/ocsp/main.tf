locals {
  common = yamldecode(file("../common.yaml"))
}

module "ocsp_infocert_ca3" {
  source = "../../../modules/ocsp"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = true
  notification = local.common.notification
  label        = "infocert ca3"
  service_name = "ocsp3ice"
}

module "ocsp_memory" {
  source = "../../../modules/ocsp-memory"

  env          = local.common.env
  network_envs = local.common.network_envs
  //network_envs  = setunion(local.common.network_envs, local.common.network_envs_aws)
  enabled       = true
  notification  = "legalcert_ticket"
  service_names = ["ocsp3ice"]
}
