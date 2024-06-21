locals {
  common = yamldecode(file("../common.yaml"))
}

# module "ogre_infocert_ca2" {
#   source = "../../../modules/ogre"

#   env          = local.common.env
#   network_envs = local.common.network_envs
#   enabled      = local.common.enabled
#   notification = local.common.notification
#   label        = "infocert ca2"
#   service_name = "ogre2ice"
# }

# module "ogre_infocert_ca3" {
#   source = "../../../modules/ogre"

#   env          = local.common.env
#   network_envs = local.common.network_envs
#   enabled      = local.common.enabled
#   notification = local.common.notification
#   label        = "infocert ca3"
#   service_name = "ogre3ice"
# }

# module "ogre_isp_ca" {
#   source = "../../../modules/ogre"

#   env          = local.common.env
#   network_envs = local.common.network_envs
#   enabled      = local.common.enabled
#   notification = local.common.notification
#   label        = "isp ca"
#   service_name = "ogreisp"
# }

module "ogre_infocert_ca2_aws" {
  source = "../../../modules/ogre"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "infocert ca2"
  service_name = "ogre2ice"
}

module "ogre_infocert_ca3_aws" {
  source = "../../../modules/ogre"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "infocert ca3"
  service_name = "ogre3ice"
}

module "ogre_infocert_ca4_aws" {
  source = "../../../modules/ogre"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "infocert ca4"
  service_name = "ogre4ice"
}

module "ogre_isp_ca_aws" {
  source="../../../modules/ogre"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "isp ca"
  service_name = "ogreisp"
}

module "ogre_isp_ca2_aws" {
  source = "../../../modules/ogre"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "isp ca2"
  service_name = "ogre2isp"
}

module "ogre_latam_ca_aws" {
  source = "../../../modules/ogre"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "latam ca"
  service_name = "ogreltm"
}

module "ogre_sogei_cns_aws" {
  source = "../../../modules/ogre"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "sogei cns"
  service_name = "ogrecns"
}

module "ogre_zuc_ca2_aws" {
  source = "../../../modules/ogre"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "zuc ca2"
  service_name = "ogre2zuc"
}

module "ogre_ifc_ca" {
  source = "../../../modules/ogre"
  env          = local.common.env
  network_envs = local.common.network_envs_ifc
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "infocamere ca"
  service_name = "ogreifc"
}
