locals {
  common = yamldecode(file("../common.yaml"))
}

module "marte_infocert" {
  source       = "../../../modules/marte"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  enable_nagios             = true
  enable_APM_duration_check = true
  duration_thresh_crt       = 10
  duration_thresh_duration  = 900
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  failure_thresh_duration   = 300
  failure_slide_by          = 30

  synthetics_map = {
    1 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "Marcatura"
      tech_serv         = "ST Marcatura Temporale"
      script_file       = "../../../modules/marte/scripts/MARTE_marcatura.tpl"
      duration_timeout  = 3000

      params_map        = {
        url  = "https://marte.infocert.it/cdie/DtsService"
        user = "MARTE_MARC_USER_PRD"
        pass = "MARTE_MARC_PASS_PRD"
      }
    }
    2 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "Marcatura Print"
      tech_serv         = "ST Marcatura Temporale"
      script_file       = "../../../modules/marte/scripts/MARTE_marcatura.tpl"
      private           = true
      private_dc        = true

      params_map        = {
        url  = "https://marte.print.infocert.it/cdie/DtsService"
        user = "MARTE_MARC_USER_PRD"
        pass = "MARTE_MARC_PASS_PRD"
      }
    }
    3 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "Marcatura Zucchetti"
      tech_serv         = "ST TSA Zucchetti"
      script_file       = "../../../modules/marte/scripts/MARTE_marcatura.tpl"
      duration_timeout  = 3000

      params_map        = {
        url  = "https://marte.zucchetti.infocert.it/cdie/DtsService"
        user = "MARTE_MARC_ZUC_USER_PRD"
        pass = "MARTE_MARC_ZUC_PASS_PRD"
      }
    }
  }
}

