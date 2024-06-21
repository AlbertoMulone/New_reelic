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
  clusterName         = "PR-Legalcert-EKS-Cluster"
  deploymentName      = "stamp-prod-deploy"

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
  enable_log_checks         = true
}
