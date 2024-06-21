locals {
  common = yamldecode(file("../common.yaml"))
}

module "pkbox_sign" {
  source = "../../../modules/pkbox-legacy"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "enterprise sign"
  service_name = "pkbox_enterprise_sign"
  nagios_checks = [
    "load",
    "disk",
    "procs",
    "procs_ntpd",
    "procs_pkbox",
    "tcp_8443_pkbox"
  ]

  enable_max_credentials = true
  enable_ssl             = true
  basic_auth             = true
  enable_balancer        = true
  balancer = {
    host = "firema.clint.infocert.it"
    port = 8443
  }
  hosts = {
    1 = {
      host = "ip1cvliaspkb001.clint.infocert.it"
      port = 8443
    }
  }
  handlers = ["default"]
}

module "pkbox_remote_enel" {
  source = "../../../modules/pkbox"

  env                    = local.common.env
  network_envs           = local.common.network_envs
  enabled                = local.common.enabled
  notification           = local.common.notification
  label                  = "remote enel"
  service_name           = "pkbox_remote_enel"
  enable_nagios          = false
  enable_max_credentials = false
  enable_ssl             = true
  verify_ssl             = false
  basic_auth             = false
  enable_balancer        = false
  hosts = {
    1 = {
      host = "ip1cvliwspkb001.clint.infocert.it"
      port = 8443
    }
    2 = {
      host = "ip1cvliwspkb002.clint.infocert.it"
      port = 8443
    }
  }
  handlers = ["default"]
}
