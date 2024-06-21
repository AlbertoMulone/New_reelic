locals {
  common = yamldecode(file("../common.yaml"))
}

module "stamp" {
  source              = "../../../modules/stamp"
  env                 = local.common.env
  network_envs        = local.common.network_envs
  enabled             = local.common.enabled
  notification        = local.common.notification
  enable_probe        = true
  enable_milan_checks = true
  clusterName         = "CL-EKS-lcert"
  deploymentName      = "stamp-coll-deploy"

  enable_APM_duration_check = true
  duration_check_type       = "static"
  duration_thresh_crt       = 0.5 # 500 ms
  duration_thresh_duration  = 300
  enable_APM_db_check       = true
  db_resp_time_thresh       = 50
  db_type                   = "Postgres"
  db_transaction_type       = "operation"
  enable_APM_failure_check  = true
  failure_thresh_crt        = 5
  enable_log_checks         = false
  failure_aggr_delay        = 30
  failure_aggr_method       = "event_flow"
  failure_aggr_window       = 600
  failure_slide_by          = 300
}
