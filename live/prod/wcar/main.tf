locals {
  common = yamldecode(file("../common.yaml"))
}

module "wcar_infora" {
  source = "../../../modules/wcar-infora"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://wcar.infocert.it/CustomerCertEmitterWS/emitterCertRequest.wsdl"
      url_num           = 1
      label             = "CustomerCertEmitterWS"
      validation_string = "EmitterCertRequestService"
      tech_serv         = "ST Registration Authority"
    }
    2 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://wcar.infocert.it/infora-webservice/RegistrationBaseAut?wsdl"
      url_num           = 1
      label             = "RegistrationBaseAut"
      validation_string = "RegistrationBaseAutService"
      tech_serv         = "ST Registration Authority"
    }
    3 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://wcar.infocert.it/infora-webservice/RegistrationHandleWS?wsdl"
      url_num           = 1
      label             = "RegistrationHandleWS"
      validation_string = "RegistrationHandleWSService"
      tech_serv         = "ST Registration Authority"
    }
    4 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://wcar.infocert.it/infora-webservice/RegistrationWS?wsdl"
      url_num           = 1
      label             = "RegistrationWS"
      validation_string = "RegistrationWSService"
      tech_serv         = "ST Registration Authority"
    }
    5 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://wcar.infocert.it/AttCertFirma/WsAccContratti?wsdl"
      url_num           = 1
      label             = "WsAccContratti"
      validation_string = "WsAccContratti"
      tech_serv         = "ST Registration Authority"
    }
    6 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://wcar.infocert.it/AttCertFirma/WsAttCerts?wsdl"
      url_num           = 1
      label             = "WsAttCerts"
      validation_string = "WsAttivazioneCerts"
      tech_serv         = "ST Registration Authority"
    }
    7 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://wcar.infocert.it/AttCertFirma/WsVerXML?wsdl"
      url_num           = 1
      label             = "WsVerXML"
      validation_string = "WsVerificaXML"
      tech_serv         = "ST Registration Authority"
    }
    8 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://wcar.infocert.it/ERCWebService/ERCNServiceWS?wsdl"
      url_num           = 1
      label             = "ERCNServiceWS"
      validation_string = "ERCServiceFRService"
      tech_serv         = "ST Registration Authority"
    }
    9 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://wcarisp.infocert.it/infora-webservice/RegistrationBaseAut?wsdl"
      url_num           = 1
      label             = "RegistrationBaseAut"
      validation_string = "RegistrationBaseAut"
      product           = "WCAR ISP"
      tech_serv         = "ST Registration Authority"
    }
  }
}
