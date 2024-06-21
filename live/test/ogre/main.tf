locals {
  common = yamldecode(file("../common.yaml"))
}

module "ogre_infocert_ca3" {
  source = "../../../modules/ogre"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = true
  notification = local.common.notification
  label        = "infocert ca3"
  service_name = "ogre3ice"
}
