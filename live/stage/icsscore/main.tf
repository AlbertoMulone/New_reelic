locals {
  common = yamldecode(file("../common.yaml"))
}

module "icsscore_infocert" {
  source = "../../../modules/icsscore"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"
  service_name = "icsscore"
  process_count = 2
}
