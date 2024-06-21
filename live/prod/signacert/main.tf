locals {
  common = yamldecode(file("../common.yaml"))
}

module "signacert_infocert_ca2" {
  source = "../../../modules/signacert"

  env               = local.common.env
  network_envs      = local.common.network_envs
  enabled           = local.common.enabled
  notification      = local.common.notification
  label             = "infocert ca2"
  service_name      = "signa2ice"
  enable_compliance = true
}

module "signacert_infocert_ca3" {
  source = "../../../modules/signacert"

  env               = local.common.env
  network_envs      = local.common.network_envs
  enabled           = local.common.enabled
  notification      = local.common.notification
  label             = "infocert ca3"
  service_name      = "signa3ice"
  enable_compliance = true
}

module "signacert_infocert_ca4" {
  source = "../../../modules/signacert"

  env               = local.common.env
  network_envs      = local.common.network_envs
  enabled           = local.common.enabled
  notification      = local.common.notification
  label             = "infocert ca4"
  service_name      = "signa4ice"
  enable_compliance = true
}

module "signacert_isp_ca" {
  source = "../../../modules/signacert"

  env               = local.common.env
  network_envs      = local.common.network_envs
  enabled           = local.common.enabled
  notification      = local.common.notification
  label             = "isp ca"
  service_name      = "signaisp"
  enable_compliance = true
}

module "signacert_isp_ca2" {
  source = "../../../modules/signacert"

  env               = local.common.env
  network_envs      = local.common.network_envs
  enabled           = local.common.enabled
  notification      = local.common.notification
  label             = "isp ca2"
  service_name      = "signa2isp"
  enable_compliance = true
}

module "signacert_zuc_ca" {
  source = "../../../modules/signacert"

  env               = local.common.env
  network_envs      = local.common.network_envs
  enabled           = local.common.enabled
  notification      = local.common.notification
  label             = "zuc ca"
  service_name      = "signazuc"
  enable_compliance = true
}

module "signacert_zuc_ca2" {
  source = "../../../modules/signacert"

  env               = local.common.env
  network_envs      = local.common.network_envs
  enabled           = local.common.enabled
  notification      = local.common.notification
  label             = "zuc ca2"
  service_name      = "signa2zuc"
  enable_compliance = true
}

# module "signacert_com_ca2" {
#   source = "../../../modules/signacert-legacy"

#   env          = local.common.env
#   network_envs = local.common.network_envs
#   enabled      = local.common.enabled
#   notification = local.common.notification
#   label        = "com ca2"
#   service_name = "signa2com"
#   nagios_checks = [
#     "load",
#     "disk",
#     "procs",
#     "procs_ntpd",
#     "procs_signacert_authd",
#     "procs_signacert_certd",
#     "procs_signacert_logd",
#     "procs_signacert_pkixd",
#     "tcp_829_pkixd",
#     "signacert_log",
#     "compliance_cert",
#     "compliance_crl"
#   ]
# }

# module "signacert_com_ca3" {
#   source = "../../../modules/signacert"

#   env               = local.common.env
#   network_envs      = local.common.network_envs
#   enabled           = local.common.enabled
#   notification      = local.common.notification
#   label             = "com ca3"
#   service_name      = "signa3com"
#   enable_compliance = true
# }

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

  env               = local.common.env
  network_envs      = local.common.network_envs
  enabled           = local.common.enabled
  notification      = local.common.notification
  label             = "cns ca"
  service_name      = "signacns"
  enable_compliance = true
}

module "signacert_ifc_ca" {
  source = "../../../modules/signacert"

  env               = local.common.env
  network_envs      = local.common.network_envs_ifc
  enabled           = local.common.enabled
  notification      = local.common.notification
  label             = "infocamere ca"
  service_name      = "signaifc"
  enable_nagios     = true
  enable_compliance = true
}
