locals {
  common = yamldecode(file("../common.yaml"))
}

module "cabe_infocert" {
  source       = "../../../modules/cabe"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  synthetics_map = {
    1 = {
      type                  = "SCRIPT_BROWSER"
      enabled               = local.common.enabled
      url_num               = 1
      label                 = "Welcome Service"
      tech_serv             = "ST Registration Authority"
      script_file           = "../../../modules/cabe/scripts/nav_CABE_login_selenium4.tpl"
      duration_timeout      = 4000
      private               = true
      private_dc            = true
      private_dc_jobmanager = true

      params_map        = {
        url               = "http://cabe.print.infocert.it/cabe-webconsole/infos"
        user              = "CABE_LOGIN_USER_PRD"
        pass              = "CABE_LOGIN_PASS_PRD"
      }
    }
  }
}
