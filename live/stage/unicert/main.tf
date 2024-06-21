locals {
  common = yamldecode(file("../common.yaml"))
}

module "unicert_identrust" {
  source = "../../../modules/unicert"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "identrust"
  service_name = "uniisp"
  hosts = {
    1 = {
      host = "vlicauniisp31.clint.infocert.it"
      port = 8080
    }
    2 = {
      host = "vlicauniisp32.clint.infocert.it"
      port = 8080
    }
  }
  handlers = ["WebHandler2_IDENTRUST_CL"]
}
