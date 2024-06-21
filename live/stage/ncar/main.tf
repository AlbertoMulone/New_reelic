locals {
  common = yamldecode(file("../common.yaml"))
}

# variables
resource "newrelic_alert_policy" "lcert_ncar_policy" {
  name = "lcert ${local.common.env} ncar infocert policy"
}

# notification
module "notification" {
  source = "../../../modules/notification"
 
  name_prefix  = "lcert ${local.common.env} ncar infocert"
  policy_id    = newrelic_alert_policy.lcert_ncar_policy.id
  notification = local.common.notification
}

# synthetics
module "ncar_synthetic" {
  source = "../../../modules/sign-synth"

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncarcl.infocert.it/regws/services/RegistrazioneAnagraficaWS?wsdl"
      url_num           = 1
      label             = "RegistrazioneAnagraficaWS"
      validation_string = "DORegistrazioneAnagraficaService"
      tech_serv         = "ST Registration Authority"
    }
    2 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncarcl.infocert.it/pcarweb/default.do"
      url_num           = 1
      label             = "Prenotazione Registrazione"
      validation_string = "Prenotazione richiesta registrazione"
      tech_serv         = "ST Registration Authority"
    }
  }

  env       = local.common.env
  policy_id = newrelic_alert_policy.lcert_ncar_policy.id
  product   = "NCAR"
}