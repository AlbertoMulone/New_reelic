locals {
  common = yamldecode(file("../common.yaml"))
}

module "trissq_infocert" {
  source          = "../../../modules/trissq"
  env             = local.common.env
  network_envs    = local.common.network_envs
  enabled         = local.common.enabled
  notification    = local.common.notification
  label           = "infocert"
  hostname_filter = "ip2pvliastrs10"
}
