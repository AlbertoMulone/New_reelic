locals {
  common = yamldecode(file("../common.yaml"))
}

module "signacert_infocert_ca2" {
  source = "../../../modules/signacert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert ca2"
  service_name = "signa2ice"
}

module "signacert_infocert_ca3" {
  source = "../../../modules/signacert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert ca3"
  service_name = "signa3ice"
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

module "signacert_isp_ca" {
  source = "../../../modules/signacert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "isp ca"
  service_name = "signaisp"
}

module "signacert_isp_ca2" {
  source = "../../../modules/signacert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "isp ca2"
  service_name = "signa2isp"
}

module "signacert_zuc_ca" {
  source = "../../../modules/signacert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "zuc ca"
  service_name = "signazuc"
}

module "signacert_zuc_ca2" {
  source = "../../../modules/signacert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "zuc ca2"
  service_name = "signa2zuc"
}

module "signacert_cmf_ca" {
  source = "../../../modules/signacert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "cmf ca"
  service_name = "signacmf"
}

module "signacert_cns_ca" {
  source = "../../../modules/signacert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "cns ca"
  service_name = "signacns"
}

module "signacert_ifc_ca" {
  source = "../../../modules/signacert"

  env               = local.common.env
  network_envs      = local.common.network_envs_ifc
  enabled           = local.common.enabled
  notification      = local.common.notification
  ntp_type          = "chronyd"
  label             = "infocamere ca"
  service_name      = "signaifc"
}
