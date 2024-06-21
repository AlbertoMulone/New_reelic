module "dashboard_apm_v2" {
  source            = "../../../modules/dashboards/apm_v2"
  create_dashboards = true

  dashboards_apm_v2 = {
    1 = {
      env             = "COLL"
      label           = "idts_coll"
      app             = "IDTS"
      service_name    = "IDTS APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'idts_coll' AND `transactionType` = 'Web' )"
    }
    2 = {
      env             = "COLL"
      label           = "shieldq_infocert_coll"
      app             = "SHIELDQ"
      service_name    = "SHIELDQ APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'shieldq_infocert_coll' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle' )"
    }
    3 = {
      env             = "COLL"
      label           = "rollq_infocert_coll"
      app             = "ROLLQ"
      service_name    = "ROLLQ APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'rollq_infocert_coll' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle' )"
    }
    4 = {
      env             = "COLL"
      label           = "icss_infocert_coll"
      app             = "ICSS"
      service_name    = "ICSS APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'icss_infocert_coll' AND `transactionType` = 'Web' )"
    }
    5 = {
      env             = "COLL"
      label           = "jimmy_infocert_coll"
      app             = "JIMMY"
      service_name    = "JIMMY APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'jimmy_infocert_coll' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle')"
    }
    6 = {
      env             = "COLL"
      label           = "jimmyq_infocert_coll"
      app             = "JIMMYQ"
      service_name    = "JIMMYQ APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'jimmyq_infocert_coll' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle')"
    }
    7 = {
      env             = "COLL"
      label           = "ncfr_infocert_coll"
      app             = "NCFR"
      service_name    = "NCFR APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'ncfr_infocert_coll' AND `name` NOT LIKE '%default%' AND `transactionType` = 'Web' )"
    }
    8 = {
      env             = "COLL"
      label           = "roll_infocert_coll"
      app             = "ROLL"
      service_name    = "ROLL APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'roll_infocert_coll' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle' )"
    }
    9 = {
      env             = "COLL"
      label           = "stamp_infocert_coll"
      app             = "STAMP"
      service_name    = "STAMP APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'stamp_infocert_coll' AND `name` NOT LIKE '%/health/ready%' AND `name` NOT LIKE '%/health/live%' AND `name` NOT LIKE '%/health%' AND `name` NOT LIKE '%Threads/Count/New Relic Sampler Service/WaitedCount%' AND `name` NOT LIKE '%TransportDuration/App%' AND `name` NOT LIKE '%/@QuarkusError%' AND `transactionType` = 'Web' )"
    }
    10 = {
      env             = "COLL"
      label           = "parsec_infocert_coll"
      app             = "PARSEC"
      service_name    = "PARSEC APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'parsec_infocert_coll' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' AND `transactionType` = 'Web' )"
    }
    11 = {
      env             = "COLL"
      label           = "nova_infocert_coll"
      app             = "NOVA"
      service_name    = "NOVA APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'nova_infocert_coll' AND `transactionType` = 'Web' AND `request.uri` != '/favicon.ico' AND `request.uri` != '/health/ready' )"
    }
    12 = {
      env             = "COLL"
      label           = "mytriss_infocert_clint"
      app             = "MYTRISS"
      service_name    = "MYTRISS APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'mytriss_infocert_clint' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/health/live (GET)' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' )"
    }
    13 = {
      env             = "COLL"
      label           = "ernst_infocert_coll"
      app             = "ERNST"
      service_name    = "ERNST APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'ernst_infocert_coll' AND `transactionType` = 'Web' AND `request.uri` != '/health/ready' )"
    }
    14 = {
      env             = "COLL"
      label           = "vaga_infocert_claws"
      app             = "VAGA"
      service_name    = "VAGA APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'vaga_infocert_claws' AND `transactionType` = 'Web' AND `request.uri` NOT LIKE '%actuator/health%')"
    }
    15 = {
    env              = "COLL"
    label            = "deck_infocert_coll"
    app              = "DECK"
    service_name     = "DECK APM"
    team             = "LegalCert"
    filter_errors    = "( `appName` = 'deck_infocert_coll' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' )"
    }
    16 = {
      env             = "COLL"
      label           = "atum_infocert_claws"
      app             = "ATUM"
      service_name    = "ATUM APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'atum_infocert_claws' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/atum/health/ready (GET)' AND `name` != 'WebTransaction/Vertx/atum/health/live (GET)' )"
    }
    17 = {
      env             = "COLL"
      label           = "nebula_infocert_coll"
      app             = "NEBULA"
      service_name    = "NEBULA APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'nebula_infocert_coll' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' )"
    }
    18 = {
      env             = "COLL"
      label           = "triss_infocert_coll"
      app             = "TRISS"
      service_name    = "TRISS APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'triss_infocert_coll' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' AND `name` != 'WebTransaction/Vertx/health/live (GET)' )"
    }
    19 = {
      env             = "COLL"
      label           = "shield_infocert_coll"
      app             = "SHIELD"
      service_name    = "SHIELD APM"
      team            = "LegalCert"
      filter_errors   = "( `appName` = 'shield_infocert_coll' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/SpringController/OperationHandler/handle' )"
    }
  }
}

module "dashboard_k8s" {
  source            = "../../../modules/dashboards/k8s/generic_service"
  create_dashboards = true

  dashboards_k8s = {
    1 = {
      env             = "COLL"
      label           = "VAGA"
      app             = "vaga_infocert_claws"
      team            = "LegalCert"
      cluster         = "CL-EKS-lcert"
      deployment      = "vaga-cl-deploy"
      namespace       = "lcert-sigval-cl-platform-namespace"
    }
    2 = {
      env             = "COLL"
      label           = "ATUM"
      app             = "atum_infocert_claws"
      team            = "LegalCert"
      cluster         = "CL-EKS-lcert"
      deployment      = "atum-cl-deploy"
      namespace       = "lcert-atum-cl-platform-namespace"
    }
  }
}

module "dashboard_k8s_stamp" {
  source            = "../../../modules/dashboards/k8s/stamp"
  create_dashboards = true

  dashboards_k8s = {
    1 = {
      env             = "COLL"
      label           = "STAMP"
      app             = "stamp_infocert_coll"
      team            = "LegalCert"
      cluster         = "CL-EKS-lcert"
      deployment1     = "stamp-coll-deploy"
      deployment2     = "stamp-admin-coll-service"
      namespace       = "lcert-stamp-cl-platform-namespace"
    }
  }
}