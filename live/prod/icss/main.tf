locals {
  common = yamldecode(file("../common.yaml"))
}

module "icss_infocert" {
  source           = "../../../modules/icss"
  env              = local.common.env
  network_envs     = local.common.network_envs
  enabled          = local.common.enabled
  notification     = local.common.notification
  label            = "infocert"
  signice_services = [
    "icss-pr1", "icss-pr2", "icss-pr3", "icss-pr4", // "icss-pr5", "icss-pr6",
    "ress-pr1", "ress-pr2"
  ]
  service_name     = "signice"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  failure_slide_by          = 30
  enable_APM_db_check       = true
  db_resp_time_thresh       = 300
  db_type                   = "Oracle"
  db_transaction_type       = "operation"

  synthetics_map = {
    1 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://icss.infocert.it/icss-rest/welcome/"
      url_num           = 1
      label             = "Welcome"
      validation_string = "Welcome to ICSS server"
      tech_serv         = "ST InfoCert Sign Server"
    }
    2 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://icss.print.infocert.it/icss-intra-rest/welcome/"
      url_num           = 1
      label             = "Welcome intra"
      validation_string = "Welcome to ICSS server"
      tech_serv         = "ST InfoCert Sign Server"
      private           = true
      private_dc        = true
    }
    3 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "https://icss.print.infocert.it/icss-intra-rest/probe/"
      url_num           = 1
      label             = "Probe intra"
      validation_string = "ICSS seems to be working properly"
      tech_serv         = "ST InfoCert Sign Server"
      private           = true
      private_dc        = true
    }
    4 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "http://vlijbsignice001.print.infocert.it:8080/icss-intra-rest/probe"
      url_num           = 1
      label             = "vlijbsignice001"
      validation_string = "ICSS seems to be working properly"
      tech_serv         = "ST InfoCert Sign Server"
      private           = true
      private_dc        = true
      verify_ssl        = false
    }
    5 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "http://vlijbsignice002.print.infocert.it:8080/icss-intra-rest/probe"
      url_num           = 1
      label             = "vlijbsignice002"
      validation_string = "ICSS seems to be working properly"
      tech_serv         = "ST InfoCert Sign Server"
      private           = true
      private_dc        = true
      verify_ssl        = false
    }
    6 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "http://vlijbsignice003.print.infocert.it:8080/icss-intra-rest/probe"
      url_num           = 1
      label             = "vlijbsignice003"
      validation_string = "ICSS seems to be working properly"
      tech_serv         = "ST InfoCert Sign Server"
      private           = true
      private_dc        = true
      verify_ssl        = false
    }
    7 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "http://vlijbsignice004.print.infocert.it:8080/icss-intra-rest/probe"
      url_num           = 1
      label             = "vlijbsignice004"
      validation_string = "ICSS seems to be working properly"
      tech_serv         = "ST InfoCert Sign Server"
      private           = true
      private_dc        = true
      verify_ssl        = false
    }
    /* 8 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "http://vlijbsignice005.print.infocert.it:8080/icss-intra-rest/probe"
      url_num           = 1
      label             = "vlijbsignice005"
      validation_string = "ICSS seems to be working properly"
      tech_serv         = "ST InfoCert Sign Server"
      private           = true
      private_dc        = true
      verify_ssl        = false
    }
    9 = {
      type              = "SIMPLE"
      enabled           = local.common.enabled
      url               = "http://vlijbsignice006.print.infocert.it:8080/icss-intra-rest/probe"
      url_num           = 1
      label             = "vlijbsignice006"
      validation_string = "ICSS seems to be working properly"
      tech_serv         = "ST InfoCert Sign Server"
      private           = true
      private_dc        = true
      verify_ssl        = false
    } */
  }
}
