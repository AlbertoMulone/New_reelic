locals {
  common = yamldecode(file("../common.yaml"))
}

module "pkbox_sign" {
  source = "../../../modules/pkbox"

  env                    = local.common.env
  network_envs           = local.common.network_envs
  enabled                = true
  notification           = local.common.notification
  label                  = "enterprise sign"
  service_name           = "pkbox_enterprise_sign"
  enable_nagios          = true
  enable_max_credentials = true
  enable_ssl             = true
  basic_auth             = true
  enable_balancer        = true
  balancer = {
    host = "firema.tsint.infocert.it"
    port = 8443
  }
  hosts = {
    1 = {
      host = "vlibpkbox21.tsint.infocert.it"
      port = 8443
    }
  }
  handlers = ["default"]
}
