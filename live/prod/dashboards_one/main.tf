module "dashboard_apache" {
  source            = "../../../modules/dashboards/apache"
  create_dashboards = true

  dashboards_apache = {
    1 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_icss_prdmz"
      app          = "ICSS"
      service_name = "ICSS Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewsfir001%' as ip1pvlewsfir001, where filename like '%ip1pvlewsfir002%' as ip1pvlewsfir002, where filename like '%ip1pvlewsfir003%' as ip1pvlewsfir003, where filename like '%ip1pvlewsfir004%' as ip1pvlewsfir004 )"
    }
    2 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_idts_prdmz"
      app          = "IDTS"
      service_name = "IDTS Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewsfir001%' as ip1pvlewsfir001, where filename like '%ip1pvlewsfir002%' as ip1pvlewsfir002, where filename like '%ip1pvlewsfir003%' as ip1pvlewsfir003, where filename like '%ip1pvlewsfir004%' as ip1pvlewsfir004 )"
    }
    3 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_marte_prdmz"
      app          = "MARTE"
      service_name = "MARTE Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewsfir001%' as ip1pvlewsfir001, where filename like '%ip1pvlewsfir002%' as ip1pvlewsfir002, where filename like '%ip1pvlewsfir003%' as ip1pvlewsfir003, where filename like '%ip1pvlewsfir004%' as ip1pvlewsfir004 )"
    }
    4 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_ncfr_prdmz"
      app          = "NCFR"
      service_name = "NCFR Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewsfir001%' as ip1pvlewsfir001, where filename like '%ip1pvlewsfir002%' as ip1pvlewsfir002, where filename like '%ip1pvlewsfir003%' as ip1pvlewsfir003, where filename like '%ip1pvlewsfir004%' as ip1pvlewsfir004, where filename like '%ip1pvlewswaf001%' as ip1pvlewswaf001, where filename like '%ip1pvlewswaf002%' as ip1pvlewswaf002, where filename like '%ip1pvlewswaf003%' as ip1pvlewswaf003, where filename like '%ip1pvlewswaf004%' as ip1pvlewswaf004  )"
    }
    5 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_ress_prdmz"
      app          = "RESS"
      service_name = "RESS Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewscer001%' as ip1pvlewscer001, where filename like '%ip1pvlewscer002%' as ip1pvlewscer002, where filename like '%ip1pvlewscer003%' as ip1pvlewscer003, where filename like '%ip1pvlewscer004%' as ip1pvlewscer004 )"
    }
    6 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_mysign_prdmz"
      app          = "MYSIGN"
      service_name = "MYSIGN Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewscer001%' as ip1pvlewscer001, where filename like '%ip1pvlewscer002%' as ip1pvlewscer002, where filename like '%ip1pvlewscer003%' as ip1pvlewscer003, where filename like '%ip1pvlewscer004%' as ip1pvlewscer004 )"
    }
    7 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_rest_prdmz"
      app          = "REST/LCRS"
      service_name = "REST/LCRS Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewscer001%' as ip1pvlewscer001, where filename like '%ip1pvlewscer002%' as ip1pvlewscer002, where filename like '%ip1pvlewscer003%' as ip1pvlewscer003, where filename like '%ip1pvlewscer004%' as ip1pvlewscer004, where filename like '%ip1pvlewswaf001%' as ip1pvlewswaf001, where filename like '%ip1pvlewswaf002%' as ip1pvlewswaf002, where filename like '%ip1pvlewswaf003%' as ip1pvlewswaf003, where filename like '%ip1pvlewswaf004%' as ip1pvlewswaf004 )"
    }
    8 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_lcrsisp_prdmz"
      app          = "LCRSISP"
      service_name = "LCRSISP Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewsisp003%' as ip1pvlewsisp003, where filename like '%ip1pvlewsisp004%' as ip1pvlewsisp004 )"
    }
    9 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_ncarisp_prdmz"
      app          = "NCARISP"
      service_name = "NCARISP Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewsisp003%' as ip1pvlewsisp003, where filename like '%ip1pvlewsisp004%' as ip1pvlewsisp004 )"
    }
    10 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_wcarisp_prdmz"
      app          = "WCARISP"
      service_name = "WCARISP Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewsisp003%' as ip1pvlewsisp003, where filename like '%ip1pvlewsisp004%' as ip1pvlewsisp004 )"
    }
    11 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_ncar_prdmz"
      app          = "NCAR"
      service_name = "NCAR Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewscer001%' as ip1pvlewscer001, where filename like '%ip1pvlewscer002%' as ip1pvlewscer002, where filename like '%ip1pvlewscer003%' as ip1pvlewscer003, where filename like '%ip1pvlewscer004%' as ip1pvlewscer004, where filename like '%ip1pvlewswaf001%' as ip1pvlewswaf001, where filename like '%ip1pvlewswaf002%' as ip1pvlewswaf002, where filename like '%ip1pvlewswaf003%' as ip1pvlewswaf003, where filename like '%ip1pvlewswaf004%' as ip1pvlewswaf004, where filename like '%vleweb01ssl%' as vleweb01ssl, where filename like '%vleweb02ssl%' as vleweb02ssl )"
    }
    12 = {
      env          = "PRDMZ"
      label        = "legalcert_apache_wcar_prdmz"
      app          = "WCAR"
      service_name = "WCAR Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvlewscer001%' as ip1pvlewscer001, where filename like '%ip1pvlewscer002%' as ip1pvlewscer002, where filename like '%ip1pvlewscer003%' as ip1pvlewscer003, where filename like '%ip1pvlewscer004%' as ip1pvlewscer004, where filename like '%ip1pvlewswaf001%' as ip1pvlewswaf001, where filename like '%ip1pvlewswaf002%' as ip1pvlewswaf002, where filename like '%ip1pvlewswaf003%' as ip1pvlewswaf003, where filename like '%ip1pvlewswaf004%' as ip1pvlewswaf004, where filename like '%vleweb01ssl%' as vleweb01ssl, where filename like '%vleweb02ssl%' as vleweb02ssl )"
    }
    13 = {
      env          = "PRINT"
      label        = "legalcert_apache_marte_print"
      app          = "MARTE"
      service_name = "MARTE Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwsfir001%' as ip1pvliwsfir001, where filename like '%ip1pvliwsfir002%' as ip1pvliwsfir002, where filename like '%ip1pvliwsfir003%' as ip1pvliwsfir003, where filename like '%ip1pvliwsfir004%' as ip1pvliwsfir004 )"
    }
    14 = {
      env          = "PRINT"
      label        = "legalcert_apache_idts_print"
      app          = "IDTS"
      service_name = "IDTS Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwsfir001%' as ip1pvliwsfir001, where filename like '%ip1pvliwsfir002%' as ip1pvliwsfir002, where filename like '%ip1pvliwsfir003%' as ip1pvliwsfir003, where filename like '%ip1pvliwsfir004%' as ip1pvliwsfir004 )"
    }
    15 = {
      env          = "PRINT"
      label        = "legalcert_apache_icss_print"
      app          = "ICSS"
      service_name = "ICSS Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwsfir001%' as ip1pvliwsfir001, where filename like '%ip1pvliwsfir002%' as ip1pvliwsfir002, where filename like '%ip1pvliwsfir003%' as ip1pvliwsfir003, where filename like '%ip1pvliwsfir004%' as ip1pvliwsfir004 )"
    }
    16 = {
      env          = "PRINT"
      label        = "legalcert_apache_ncfr_print"
      app          = "NCFR"
      service_name = "NCFR Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwsfir001%' as ip1pvliwsfir001, where filename like '%ip1pvliwsfir002%' as ip1pvliwsfir002, where filename like '%ip1pvliwsfir003%' as ip1pvliwsfir003, where filename like '%ip1pvliwsfir004%' as ip1pvliwsfir004 )"
    }
    17 = {
      env          = "PRINT"
      label        = "legalcert_apache_wcar_print"
      app          = "WCAR"
      service_name = "WCAR Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwscer001%' as ip1pvliwscer001, where filename like '%ip1pvliwscer002%' as ip1pvliwscer002, where filename like '%ip1pvliwscer003%' as ip1pvliwscer003, where filename like '%ip1pvliwscer004%' as ip1pvliwscer004 )"
    }
    18 = {
      env          = "PRINT"
      label        = "legalcert_apache_cabe_print"
      app          = "CABE"
      service_name = "CABE Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwscer001%' as ip1pvliwscer001, where filename like '%ip1pvliwscer002%' as ip1pvliwscer002, where filename like '%ip1pvliwscer003%' as ip1pvliwscer003, where filename like '%ip1pvliwscer004%' as ip1pvliwscer004 )"
    }
    19 = {
      env          = "PRINT"
      label        = "legalcert_apache_rest_print"
      app          = "REST/LCRS"
      service_name = "REST/LCRS Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwscer001%' as ip1pvliwscer001, where filename like '%ip1pvliwscer002%' as ip1pvliwscer002, where filename like '%ip1pvliwscer003%' as ip1pvliwscer003, where filename like '%ip1pvliwscer004%' as ip1pvliwscer004 )"
    }
    20 = {
      env          = "PRINT"
      label        = "legalcert_apache_ncar_print"
      app          = "NCAR"
      service_name = "NCAR Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwscer001%' as ip1pvliwscer001, where filename like '%ip1pvliwscer002%' as ip1pvliwscer002, where filename like '%ip1pvliwscer003%' as ip1pvliwscer003, where filename like '%ip1pvliwscer004%' as ip1pvliwscer004 )"
    }
    21 = {
      env          = "PRINT"
      label        = "legalcert_apache_ress_print"
      app          = "RESS"
      service_name = "RESS Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwscer001%' as ip1pvliwscer001, where filename like '%ip1pvliwscer002%' as ip1pvliwscer002, where filename like '%ip1pvliwscer003%' as ip1pvliwscer003, where filename like '%ip1pvliwscer004%' as ip1pvliwscer004 )"
    }
    22 = {
      env          = "PRINT"
      label        = "legalcert_apache_sere_print"
      app          = "SERE"
      service_name = "SERE Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwscer001%' as ip1pvliwscer001, where filename like '%ip1pvliwscer002%' as ip1pvliwscer002, where filename like '%ip1pvliwscer003%' as ip1pvliwscer003, where filename like '%ip1pvliwscer004%' as ip1pvliwscer004 )"
    }
    23 = {
      env          = "PRINT"
      label        = "legalcert_apache_wcarisp_print"
      app          = "WCARISP"
      service_name = "WCARISP Apache FE"
      team         = "LegalCert"
      facet_filter = "FACET cases( where filename like '%ip1pvliwsisp001%' as ip1pvliwsisp001, where filename like '%ip1pvliwsisp002%' as ip1pvliwsisp002 )"
    }
  }
}

module "dashboard_apm_v2" {
  source            = "../../../modules/dashboards/apm_v2"
  create_dashboards = true

  dashboards_apm_v2 = {
    1 = {
      env             = "PROD"
      label           = "idts_prod"
      app             = "IDTS"
      service_name    = "IDTS APM"
      team            = "LegalCert"
      filter_errors   = "`appName` = 'idts_prod' AND `transactionType` = 'Web'"
    }
    2 = {
      env             = "PROD"
      label           = "shieldq_infocert_prod"
      app             = "SHIELDQ"
      service_name    = "SHIELDQ APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'shieldq_infocert_prod' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle' )"
    }
    3 = {
      env             = "PROD"
      label           = "rollq_infocert_prod"
      app             = "ROLLQ"
      service_name    = "ROLLQ APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'rollq_infocert_prod' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle' )"
    }
    4 = {
      env             = "PROD"
      label           = "icss_infocert_prod"
      app             = "ICSS"
      service_name    = "ICSS APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'icss_infocert_prod' AND `transactionType` = 'Web' )"
    }
    5 = {
      env             = "PROD"
      label           = "jimmy_infocert_prod"
      app             = "JIMMY"
      service_name    = "JIMMY APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'jimmy_infocert_prod' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle')"
    }
    6 = {
      env             = "PROD"
      label           = "jimmyq_infocert_prod"
      app             = "JIMMYQ"
      service_name    = "JIMMYQ APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'jimmyq_infocert_prod' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle')"
    }
    7 = {
      env             = "PROD"
      label           = "ncfr_infocert_prod"
      app             = "NCFR"
      service_name    = "NCFR APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'ncfr_infocert_prod' AND `name` NOT LIKE '%default%' AND `transactionType` = 'Web' )"
    }
    8 = {
      env             = "PROD"
      label           = "roll_infocert_prod"
      app             = "ROLL"
      service_name    = "ROLL APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'roll_infocert_prod' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle' )"
    }
    9 = {
      env             = "PROD"
      label           = "stamp_infocert_prod"
      app             = "STAMP"
      service_name    = "STAMP APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'stamp_infocert_prod' AND `name` NOT LIKE '%/health/ready%' AND `name` NOT LIKE '%/health/live%' AND `name` NOT LIKE '%/health%' AND `name` NOT LIKE '%Threads/Count/New Relic Sampler Service/WaitedCount%' AND `name` NOT LIKE '%TransportDuration/App%' AND `name` NOT LIKE '%/@QuarkusError%' AND `transactionType` = 'Web' )"
    }
    10 = {
      env             = "PROD"
      label           = "parsec_infocert_prod"
      app             = "PARSEC"
      service_name    = "PARSEC APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'parsec_infocert_prod' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' AND `transactionType` = 'Web' )"
    }
    11 = {
      env             = "PROD"
      label           = "nova_infocert_prod"
      app             = "NOVA"
      service_name    = "NOVA APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'nova_infocert_prod' AND `transactionType` = 'Web' AND `request.uri` != '/favicon.ico' AND `request.uri` != '/health/ready' )"
    }
    12 = {
      env             = "PROD"
      label           = "mytriss_infocert_print"
      app             = "MYTRISS"
      service_name    = "MYTRISS APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'mytriss_infocert_print' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/health/live (GET)' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' )"
    }
    13 = {
      env             = "PROD"
      label           = "ernst_infocert_prod"
      app             = "ERNST"
      service_name    = "ERNST APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'ernst_infocert_prod' AND `transactionType` = 'Web' AND `request.uri` != '/health/ready' )"
    }
    14 = {
      env             = "PROD"
      label           = "vaga_infocert_praws"
      app             = "VAGA"
      service_name    = "VAGA APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'vaga_infocert_praws' AND `transactionType` = 'Web' AND `request.uri` NOT LIKE '%actuator/health%')"
    }
    15 = {
    env              = "PROD"
    label            = "deck_infocert_prod"
    app              = "DECK"
    service_name     = "DECK APM"
    team             = "LegalCert"
    filter_errors    = "( `appName` = 'deck_infocert_prod' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' )"
    }
    16 = {
      env             = "PROD"
      label           = "atum_infocert_praws"
      app             = "ATUM"
      service_name    = "ATUM APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'atum_infocert_praws' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/atum/health/ready (GET)' AND `name` != 'WebTransaction/Vertx/atum/health/live (GET)' )"
    }
    17 = {
      env             = "PROD"
      label           = "nebula_infocert_prod"
      app             = "NEBULA"
      service_name    = "NEBULA APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'nebula_infocert_prod' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' )"
    }
    18 = {
      env             = "PROD"
      label           = "triss_infocert_prod"
      app             = "TRISS"
      service_name    = "TRISS APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'triss_infocert_prod' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' AND `name` != 'WebTransaction/Vertx/health/live (GET)' )"
    }
    19 = {
      env             = "PROD"
      label           = "shield_infocert_prod"
      app             = "SHIELD"
      service_name    = "SHIELD APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'shield_infocert_prod' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle' )"
    }
    20 = {
      env             = "PROD"
      label           = "parsec_isp_prod"
      app             = "PARSEC ISP"
      service_name    = "PARSEC APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'parsec_isp_prod' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' AND `transactionType` = 'Web' )"
    }
    21 = {
      env             = "PROD"
      label           = "nova_isp_prod"
      app             = "NOVA ISP"
      service_name    = "NOVA APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'nova_isp_prod' AND `transactionType` = 'Web' AND `request.uri` != '/favicon.ico' AND `request.uri` != '/health/ready' )"
    }
  }
}

module "dashboard_isp" {
  source            = "../../../modules/dashboards/isp"
  create_dashboards = true

  dashboards_isp_overview = {
    1 = {
      env  = "PROD"
      team = "LegalCert"
    }
  }
}

module "dashboard_k8s" {
  source            = "../../../modules/dashboards/k8s/generic_service"
  create_dashboards = true

  dashboards_k8s = {
    1 = {
      env             = "PROD"
      label           = "VAGA"
      app             = "vaga_infocert_praws"
      team            = "LegalCert"
      cluster         = "PR-Legalcert-EKS-Cluster"
      deployment      = "vaga-pr-deploy"
      namespace       = "lcert-sigval-pr-platform-namespace"
    }
    2 = {
      env             = "PROD"
      label           = "ATUM"
      app             = "atum_infocert_praws"
      team            = "LegalCert"
      cluster         = "PR-Legalcert-EKS-Cluster"
      deployment      = "atum-pr-deploy"
      namespace       = "lcert-atum-pr-platform-namespace"
    }
  }
}

module "dashboard_k8s_stamp" {
  source            = "../../../modules/dashboards/k8s/stamp"
  create_dashboards = true

  dashboards_k8s = {
    1 = {
      env             = "PROD"
      label           = "STAMP"
      app             = "stamp_infocert_prod"
      team            = "LegalCert"
      cluster         = "PR-Legalcert-EKS-Cluster"
      deployment1     = "stamp-prod-deploy"
      deployment2     = "stamp-admin-prod-service"
      namespace       = "lcert-stamp-pr-platform-namespace"
    }
  }
}