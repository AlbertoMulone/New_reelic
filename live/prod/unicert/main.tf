locals {
  common = yamldecode(file("../common.yaml"))
}

module "unicert_identrust" {
  source = "../../../modules/unicert"

  env               = local.common.env
  network_envs      = local.common.network_envs
  enabled           = local.common.enabled
  notification      = local.common.notification
  label             = "identrust"
  service_name      = "uniisp"
  enable_nagios     = true
  enable_compliance = true
  location_ca       = true
  hosts = {
    1 = {
      host = "vlicauniisp01.ca.infocert.it"
      port = 8080
    }
    2 = {
      host = "vlicauniisp02.ca.infocert.it"
      port = 8080
    }
  }
  handlers = ["WebHandler2_IDENTRUST"]
}
