locals {
  common = yamldecode(file("../common.yaml"))
}

module "ncar_infocert" {
  source         = "../../../modules/ncar"
  env            = local.common.env
  network_envs   = local.common.network_envs
  enabled        = local.common.enabled
  notification   = "legalcert_ticket"

  synthetics_map = {
    1 = {
      type                  = "SCRIPT_BROWSER"
      enabled               = local.common.enabled
      url_num               = 1
      label                 = "FrontEnd Login"
      tech_serv             = "ST Registration Authority"
      script_file           = "../../../modules/ncar/scripts/nav_NCAR_login.tpl"
      duration_timeout      = 8000

      params_map        = {
        url               = "https://ncar.infocert.it/ncar/"
        user              = "NCAR_LOGIN_USER_PRD"
        pass              = "NCAR_LOGIN_PASS_PRD"
      }
    }
    2 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncar.infocert.it/regws/services/RegistrazioneAnagraficaWS?wsdl"
      url_num           = 1
      label             = "RegistrazioneAnagraficaWS"
      validation_string = "DORegistrazioneAnagraficaService"
      tech_serv         = "ST Registration Authority"
    }
    3 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncar.infocert.it/pcarweb/default.do"
      url_num           = 1
      label             = "Prenotazione Registrazione"
      validation_string = "Prenotazione richiesta registrazione"
      tech_serv         = "ST Registration Authority"
    }
    4 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncarisp.infocert.it/regws/services/RegistrazioneAnagraficaWS?wsdl"
      url_num           = 1
      label             = "RegistrazioneAnagraficaWS"
      validation_string = "DORegistrazioneAnagraficaService"
      product           = "NCAR ISP"
      tech_serv         = "ST Registration Authority"
    }
  }
}
