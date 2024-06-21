locals {
  common = yamldecode(file("../common.yaml"))
}

module "jblcert" {
  source       = "../../../modules/jblcert"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  service_name = "jblcert"
  jblcert_services = [
    "cartaweb-pr1", "cartaweb-pr2",
    "ptit-pr1", "ptit-pr2",
    "pulce-pr1", "pulce-pr2",
    "sere-pr1", "sere-pr2",
  ]
}
