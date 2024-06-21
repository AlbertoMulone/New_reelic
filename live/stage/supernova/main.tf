locals {
  common = yamldecode(file("../common.yaml"))
}

module "supernova_infocert" {
  source       = "../../../modules/supernova"
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
      label                 = "Login Supernova"
      tech_serv             = "ST Registration Authority 2"
      script_file           = "../../../modules/supernova/scripts/nav_SUPERNOVA_templates_selenium4.tpl"
      duration_timeout      = 10000
      private               = true
      private_dc            = true
      private_dc_jobmanager = true

      params_map        = {
        url               = "https://supernova.clint.infocert.it/login?redirect=%2Fhome"
        user              = "SUPERNOVA_LOGIN_USER_CLD"
        pass              = "SUPERNOVA_LOGIN_PASS_CLD"
        validation_string = "ma233699"
      }
    }
  }
}
