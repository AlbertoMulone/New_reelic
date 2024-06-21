locals {
  common = yamldecode(file("../common.yaml"))
}

/*
module "ncfr_infocert" {
  source               = "../../../modules/ncfr"
  env                  = local.common.env
  network_envs         = local.common.network_envs
  enabled              = local.common.enabled
  notification         = local.common.notification
  label                = "infocert"
  enable_apache_checks = false
}
*/

module "ncfr" {
  source               = "../../../modules/ncfr"
  env                  = local.common.env
  network_envs         = local.common.network_envs
  enabled              = local.common.enabled
  notification         = local.common.notification
  label                = "infocert"
  enable_apache_checks = true
  apache_checks_info = {
    1 = {
      net_env      = "print"
      tag          = "legalcert_apache_ncfr_print"
      elaps_thresh = 2
    }
    2 = {
      net_env      = "prdmz"
      tag          = "legalcert_apache_ncfr_prdmz"
      elaps_thresh = 1
    }
  }

  enable_APM_duration_check   = true
  duration_thresh_crt         = 45
  duration_thresh_duration    = 600
  duration_aggregation_delay  = 60
  duration_aggregation_window = 1200
  duration_slide_by           = 600

  #enable_APM_db_check       = false
  #db_resp_time_thresh       = 50
  #db_type                   = "Postgres"
  #db_transaction_type       = "operation"
  #enable_APM_failure_check  = true
  #failure_thresh_crt        = 0.50

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncfr.infocert.it/ncfr-webservice/FirmaFR?wsdl"
      url_num           = 1
      label             = "FirmaFR"
      validation_string = "FirmaFR"
      tech_serv         = "ST Firma Remota Intesi"
    }
    2 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncfr.infocert.it/ncfr-webservice/FirmaWS?wsdl"
      url_num           = 1
      label             = "FirmaWS"
      validation_string = "firmaWSService"
      tech_serv         = "ST Firma Remota Intesi"
    }
    3 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncfr.infocert.it/ncfr-webservice/GenCertFR?wsdl"
      url_num           = 1
      label             = "GenCertFR"
      validation_string = "GenCertFR"
      tech_serv         = "ST Firma Remota Intesi"
    }
    4 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncfr.infocert.it/ncfr-webservice/GenCertMedWS?wsdl"
      url_num           = 1
      label             = "GenCertMedWS"
      validation_string = "GenCertMedService"
      tech_serv         = "ST Firma Remota Intesi"
    }
    5 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncfr.infocert.it/ncfr-webservice/RegCertFR?wsdl"
      url_num           = 1
      label             = "RegCertFR"
      validation_string = "RegCertFR"
      tech_serv         = "ST Firma Remota Intesi"
    }
    6 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncfr.infocert.it/ncfr-webservice/ManagerCredWS?wsdl"
      url_num           = 1
      label             = "ManagerCredWS"
      validation_string = "ManagerCredWSService"
      tech_serv         = "ST Firma Remota Intesi"
    }
    7 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncfr.infocert.it/ncfr-webservice/RegCertMedWS?wsdl"
      url_num           = 1
      label             = "RegCertMedWS"
      validation_string = "RegCertMed"
      tech_serv         = "ST Firma Remota Intesi"
    }
    8 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncfr.infocert.it/ncfr-webservice/OTPSender?wsdl"
      url_num           = 1
      label             = "OTPSender"
      validation_string = "OTPSenderWSService"
      tech_serv         = "ST Firma Remota Intesi"
    }
    9 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncfr.infocert.it/ncfr-webservice/PKBoxManager?wsdl"
      url_num           = 1
      label             = "PKBoxManager"
      validation_string = "GenerateCertificatePKBoxService"
      tech_serv         = "ST Firma Remota Intesi"
    }
    10 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ncfr.infocert.it/ncfr-webservice/ServerMaRe?wsdl"
      url_num           = 1
      label             = "ServerMaRe"
      validation_string = "ServerMaRe"
      tech_serv         = "ST Firma Remota Intesi"
    }
    11 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ip1pvliwsfir001.print.infocert.it:50443/ncfr-webservice/FirmaFR?wsdl"
      url_num           = 1
      label             = "FirmaFR - Apache instance 001"
      validation_string = "FirmaFR"
      tech_serv         = "ST Firma Remota Intesi"
      private           = true
      private_dc        = true
    }
    12 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ip1pvliwsfir002.print.infocert.it:50443/ncfr-webservice/FirmaFR?wsdl"
      url_num           = 1
      label             = "FirmaFR - Apache instance 002"
      validation_string = "FirmaFR"
      tech_serv         = "ST Firma Remota Intesi"
      private           = true
      private_dc        = true
    }
    13 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ip1pvliwsfir003.print.infocert.it:50443/ncfr-webservice/FirmaFR?wsdl"
      url_num           = 1
      label             = "FirmaFR - Apache instance 003"
      validation_string = "FirmaFR"
      tech_serv         = "ST Firma Remota Intesi"
      private           = true
      private_dc        = true
    }
    14 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://ip1pvliwsfir004.print.infocert.it:50443/ncfr-webservice/FirmaFR?wsdl"
      url_num           = 1
      label             = "FirmaFR - Apache instance 004"
      validation_string = "FirmaFR"
      tech_serv         = "ST Firma Remota Intesi"
      private           = true
      private_dc        = true
    } 
    15 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "FirmaCADES"
      tech_serv         = "ST Firma Remota Intesi"
      script_file       = "../../../modules/ncfr/scripts/NCFR_firma_CADES.tpl"

      params_map        = {
        url   = "https://ncfr.infocert.it/ncfr-webservice/FirmaFR"
        validation_string  = "Operazione terminata con successo"
      }
    }
  }
}