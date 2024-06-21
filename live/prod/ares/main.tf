locals {
  common = yamldecode(file("../common.yaml"))
}

module "ares_infocert" {
  source       = "../../../modules/ares"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  synthetics_map = {
    1 = {
      type              = "SCRIPT_API"
      enabled           = false
      url_num           = 1
      label             = "Certificate Status"
      tech_serv         = "ST-ATUM"
      script_file       = "../../../modules/ares/scripts/ARES_certificate_status.tpl"
      duration_timeout  = 8000

      params_map        = {
        aresurl  = "https://api.infocert.digital/certificate/v1/FAKEIUTARESTSTSND/status"
        idpurl   = "https://idp.infocert.digital/auth/realms/delivery/protocol/openid-connect/token"
        idpcreds = "ARES_PROD_IDP_CREDENTIALS"
      }
    }
  }
}
