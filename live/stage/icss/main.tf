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
  signice_services = ["icss-cl1", "icss-cl2", "ress-cl1", "ress-cl2"]
  service_name     = "signice"

  enable_APM_duration_check = true
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  failure_slide_by          = 30
  enable_APM_db_check       = true
  db_resp_time_thresh       = 100
  db_type                   = "Oracle"
  db_transaction_type       = "operation"
}
