locals {
  common = yamldecode(file("../common.yaml"))
}

module "ogre_infocert_ca2_aws" {
  source="../../../modules/ogre"

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
  source = "../../../modules/ogre"

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

# module "ogre_certicomm_ca3_aws" {
#   source = "../../../modules/ogre"

#   env          = local.common.env_aws
#   network_envs = local.common.network_envs_aws
#   enabled      = local.common.enabled
#   notification = local.common.notification
#   label        = "certicomm ca3"
#   service_name = "ogre3com"
# }

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

module "ogre_cmf_ssl_aws" {
  source = "../../../modules/ogre"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "cmf ssl"
  service_name = "ogrecmfssl"
}

module "ogre_ifc_ca" {
  source = "../../../modules/ogre"

  env          = local.common.env
  network_envs = local.common.network_envs_ifc
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocamere ca"
  service_name = "ogreifc"
}

# aws oracle maintenance window muting rule 
resource "newrelic_alert_muting_rule" "ogre_muting_rule" {
  name        = "lcert ${local.common.env_aws} ogre oracle maintenance window"
  enabled     = true
  description = "aws oracle maintenance window muting rule"

  condition {
    conditions {
      attribute = "policyName"
      operator  = "CONTAINS"
      values    = ["${local.common.env_aws} ogre"]
    }
    operator = "AND"
  }

  schedule {
    start_time = "2021-10-17T00:30:00"
    end_time   = "2021-10-17T01:00:00"
    time_zone  = "UTC"
    repeat     = "WEEKLY"

    weekly_repeat_days = ["SUNDAY"]
  }
}
