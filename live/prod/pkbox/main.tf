locals {
  common = yamldecode(file("../common.yaml"))
}

module "pkbox_sign" {
  source = "../../../modules/pkbox"

  env                    = local.common.env
  network_envs           = local.common.network_envs
  enabled                = local.common.enabled
  notification           = local.common.notification
  label                  = "enterprise sign"
  service_name           = "pkbox_enterprise_sign"
  pkbox_command_line     = "/usr/PkBox8/java/default/bin/java"
  high_cpu_usage_percent = 500
  enable_ntpd_check      = true
  enable_nagios          = true
  enable_max_credentials = true
  max_credentials_limit  = 95
  enable_ssl             = true
  basic_auth             = true
  enable_balancer        = true
  balancer = {
    host = "firema.print.infocert.it"
    port = 8443
  }
  hosts = {
    1 = {
      host = "libpkbox001.print.infocert.it"
      port = 8443
    }
    2 = {
      host = "libpkbox002.print.infocert.it"
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
      host = "ip1pvliwspkb001.print.infocert.it"
      port = 8443
    }
    2 = {
      host = "ip1pvliwspkb002.print.infocert.it"
      port = 8443
    }
  }
  handlers = ["default"]
}
