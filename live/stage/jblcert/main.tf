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
    "marca-cl1", "marca-cl2",
    "ptit-cl1", "ptit-cl2",
    "pulce-cl1", "pulce-cl2",
    "sere-cl1", "sere-cl2",
  ]
}
