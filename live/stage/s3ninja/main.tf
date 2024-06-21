locals {
  common = yamldecode(file("../common.yaml"))
}

module "s3ninja_ifc" {
  source = "../../../modules/s3ninja"

  env           = local.common.env
  network_envs  = local.common.network_envs_ifc
  enabled       = local.common.enabled
  notification  = local.common.notification
  label         = "ifc"
  service_name  = "s3ninja"
}
