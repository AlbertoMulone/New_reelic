locals {
  common = yamldecode(file("../common.yaml"))
}

module "stargate_isp_ca2_aws_pg" {
  source = "../../../modules/stargate"

  env            = local.common.env_aws
  network_envs   = local.common.network_envs_aws
  enabled        = local.common.enabled
  notification   = local.common.notification
  label          = "isp ca2"
  deploymentName = "stargate-signa2isp-pg"
  labels_release = "signa2isp-pg"
  clusterName    = "CL-CA-EKS-BC-CLUSTER"
}

module "stargate_infocert_ca4_aws_pg" {
  source = "../../../modules/stargate"

  env            = local.common.env_aws
  network_envs   = local.common.network_envs_aws
  enabled        = local.common.enabled
  notification   = local.common.notification
  label          = "infocert ca4"
  deploymentName = "stargate-signa4ice-pg"
  labels_release = "signa4ice-pg"
  clusterName    = "CL-CA-EKS-BC-CLUSTER"
}

module "stargate_camerfirma_ca_aws_pg" {
  source = "../../../modules/stargate"

  env            = local.common.env_aws
  network_envs   = local.common.network_envs_aws
  enabled        = local.common.enabled
  notification   = local.common.notification
  label          = "camerfirma ca"
  deploymentName = "stargate-signacmf-pg"
  labels_release = "signacmf-pg"
  clusterName    = "CL-CA-EKS-BC-CLUSTER"
}
