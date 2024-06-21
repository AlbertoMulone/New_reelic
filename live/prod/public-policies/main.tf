locals {
  common = yamldecode(file("../common.yaml"))
}

module "public-stamp" {
  source = "../../../modules/public-policies/public-stamp"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
}

module "public-wormhole" {
  source = "../../../modules/public-policies/public-wormhole"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  nrql_checks_info = {
    wormhole = {
      label         = "HealthCheck"
      product       = "WORMHOLE"
      sythetic_name = "SIGN | WORMHOLE | PROD | Health Check - printbc"
    }
  }
}

module "public-isp-crl" {
  source = "../../../modules/public-policies/public-isp-crl"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
}

module "public-isp-ocsp" {
  source = "../../../modules/public-policies/public-isp-ocsp"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
}
