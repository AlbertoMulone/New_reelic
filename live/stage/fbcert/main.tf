locals {
  common = yamldecode(file("../common.yaml"))
}

module "fbcertice" {
  source       = "../../../modules/fbcert"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  basename     = "fbcert"
  label        = "infocert"
  instances = [
    "emis", "fire", "marca", "zucmarca", "regs", "regsext", "restcert",
    "cabeejb", "regsejb", "firmaejb", "fireejb", "restcertejb", "ncfrejb"
  ]
  service_name = "fbcertice"
}
