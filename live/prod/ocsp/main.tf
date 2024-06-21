locals {
  common = yamldecode(file("../common.yaml"))
}

module "ocsp_infocert_ca2_aws" {
  source="../../../modules/ocsp"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "infocert ca2"
  service_name = "ocsp2ice"
}

module "ocsp_infocert_ca3_aws" {
  source = "../../../modules/ocsp"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "infocert ca3"
  service_name = "ocsp3ice"
}

module "ocsp_infocert_ca4_aws" {
  source = "../../../modules/ocsp"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "infocert ca4"
  service_name = "ocsp4ice"
}

module "ocsp_isp_ca_aws" {
  source = "../../../modules/ocsp"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "isp ca"
  service_name = "ocspisp"
}

module "ocsp_isp_ca2_aws" {
  source = "../../../modules/ocsp"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "isp ca2"
  service_name = "ocsp2isp"
}

# module "ocsp_certicomm_ca3_aws" {
#   source = "../../../modules/ocsp"

#   env          = local.common.env_aws
#   network_envs = local.common.network_envs_aws
#   enabled      = local.common.enabled
#   notification = local.common.notification
#   label        = "certicomm ca3"
#   service_name = "ocsp3com"
# }

module "ocsp_latam_ca_aws" {
  source = "../../../modules/ocsp"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "latam ca"
  service_name = "ocspltm"
}

module "ocsp_sogei_cns_aws" {
  source = "../../../modules/ocsp"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "sogei cns"
  service_name = "ocspcns"
}

module "ocsp_zuc_ca2_aws" {
  source = "../../../modules/ocsp"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "zuc ca2"
  service_name = "ocsp2zuc"
}

module "ocsp_cmf_ssl_aws" {
  source = "../../../modules/ocsp"

  env          = local.common.env_aws
  network_envs = local.common.network_envs_aws
  enabled      = local.common.enabled
  notification = local.common.notification
  ntp_type     = "chronyd"
  label        = "cmf ssl"
  service_name = "ocspcmfssl"
}

module "ocsp_ifc_ca" {
  source = "../../../modules/ocsp"

  env          = local.common.env
  network_envs = local.common.network_envs_ifc
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocamere ca"
  service_name = "ocspifc"
}

module "ocsp_memory" {
  source = "../../../modules/ocsp-memory"

  env          = local.common.env
  network_envs = setunion(local.common.network_envs, local.common.network_envs_aws)
  enabled      = local.common.enabled
  notification = "legalcert_ticket"
  service_names = [
    "ocsp2ice",
    "ocsp3ice",
    "ocsp4ice",
    "ocspisp",
    "ocsp2isp",
    "ocspltm",
    "ocspcns",
    "ocsp2zuc",
    "ocspcmfssl"
  ]
}

# aws oracle maintenance window muting rule 
resource "newrelic_alert_muting_rule" "ocsp_muting_rule" {
  name        = "lcert ${local.common.env_aws} ocsp oracle maintenance window"
  enabled     = true
  description = "aws oracle maintenance window muting rule"

  condition {
    conditions {
      attribute = "policyName"
      operator  = "CONTAINS"
      values    = ["${local.common.env_aws} ocsp"]
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
