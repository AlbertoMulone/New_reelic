locals {
  common = yamldecode(file("../common.yaml"))
}

module "lccb" {
  source         = "../../../modules/lccb"
  env            = local.common.env_aws
  enabled        = local.common.enabled
  notification   = local.common.notification
  clusterName    = "PR-Legalcert-EKS-Cluster"
  deploymentName = "lccb-pr"

  enable_APM_duration_check = true
  duration_thresh_crt       = 5
  enable_APM_db_check       = true
  db_resp_time_thresh       = 50
  db_type                   = "Postgres"
  db_transaction_type       = "operation"
  enable_APM_failure_check  = false # fix app before enable
  failure_thresh_crt        = 5
  enable_log_checks         = false
  failure_aggr_delay        = 30
  failure_aggr_method       = "event_flow"
  failure_aggr_window       = 600
  failure_slide_by          = 300
}
