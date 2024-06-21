locals {
  common = yamldecode(file("../common.yaml"))
}

module "mysign" {
  source = "../../../modules/mysign"

  env           = local.common.env
  network_envs  = local.common.network_envs
  enabled       = local.common.enabled
  notification  = local.common.notification
  service_name  = "mysign"
  enable_nagios = true

  synthetics_map = {
    1 = {
      type             = "SCRIPT_BROWSER"
      enabled          = local.common.enabled
      url_num          = 1
      label            = "Login MySign"
      tech_serv        = "ST Firma Remota Intesi"
      script_file      = "../../../modules/mysign/scripts/nav_MYSIGN_login_new.tpl"
      duration_timeout = 15000

      params_map        = {
        url  = "https://mysign.infocert.it/#/login"
        user = "MYSIGN_LOGIN_USER_PRD"
        pass = "MYSIGN_LOGIN_PASS_PRD"
      }
    }
  }
}