locals {
  common = yamldecode(file("../common.yaml"))
}

module "wcrs" {
  source = "../../../modules/wcrs"

  env                          = local.common.env
  network_envs                 = local.common.network_envs
  notification                 = local.common.notification
  enable_API_checks            = true
  
  wcrs_scripted_API_checks = {
    1 = {
      enabled       = local.common.enabled
      url           = "https://wcar.clint.infocert.it/infora-webservice/RegistrationBaseAut"
      label         = "Registration Base Aut"
      code          = 200
      check_string  = "<identificativo>0-ICSS00000010420623</identificativo>"
      authorization = "VEVTVFJBTzI6aW5mb2NlcnQx"
      script        = "wcar_scripted_api.tpl"
      user          = ""
      pass          = ""
      priv_loc      = true
      frequency     = 5
      duration_thr  = 5000
      result_thr    = 1500
    }
  }
}