locals {
  common = yamldecode(file("../common.yaml"))
}

module "carpediem_infocert" {
  source = "../../../modules/carpediem"

  env           = local.common.env
  network_envs  = local.common.network_envs
  enabled       = local.common.enabled
  notification  = local.common.notification
  label         = "infocert"
  service_name  = "carpeice"

  enable_compliance = true
}

module "carpediem_zuc" {
  source = "../../../modules/carpediem"

  env           = local.common.env
  network_envs  = local.common.network_envs
  enabled       = local.common.enabled
  notification  = local.common.notification
  label         = "zuc"
  service_name  = "carpezuc"

  enable_compliance = true
}

module "carpediem_cmf" {
  source = "../../../modules/carpediem"

  env           = local.common.env
  network_envs  = local.common.network_envs
  enabled       = local.common.enabled
  notification  = local.common.notification
  label         = "cmf"
  service_name  = "carpecmf"

  enable_compliance = true
}

module "carpediem_infocamere" {
  source = "../../../modules/carpediem"

  env           = local.common.env
  network_envs  = local.common.network_envs_ifc
  enabled       = local.common.enabled
  notification  = local.common.notification
  label         = "infocamere"
  service_name  = "marcaifc"
  enable_nagios = true
}

module "carpediem_ifc" {
  source = "../../../modules/carpediem"

  env           = local.common.env
  network_envs  = local.common.network_envs_ifc
  enabled       = local.common.enabled
  notification  = local.common.notification
  label         = "ifc"
  service_name  = "carpeifc"

  enable_compliance = true
}
