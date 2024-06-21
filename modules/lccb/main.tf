# policy
resource "newrelic_alert_policy" "lcert_lccb_policy" {
  name = "lcert ${var.env} lccb policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} lccb"
  policy_id    = newrelic_alert_policy.lcert_lccb_policy.id
  notification = var.notification
}

# infra
module "k8s_infra" {
  source = "../infra-k8s"

  policy_id = newrelic_alert_policy.lcert_lccb_policy.id
  filter    = "( `clusterName` = '${var.clusterName}' AND `deploymentName` = '${var.deploymentName}' )"
  enabled   = var.enabled
}

# LCCB AWS
module "apm_v2" {
  source = "../apm_v2"

  policy_id     = newrelic_alert_policy.lcert_lccb_policy.id
  filter_app    = "( `appName` = 'lccb_infocert_${var.env}' )"
  filter_trnsct = "(`appName` = 'lccb_infocert_${var.env}' AND `name` LIKE '%/claim%' OR name like '%/token%' or name ='WebTransaction/Vertx/ (POST)')"
  enabled       = var.enabled

  enable_APM_duration_check = var.enable_APM_duration_check
  duration_thresh_crt       = var.duration_thresh_crt
  enable_APM_failure_check  = var.enable_APM_failure_check
  failure_thresh_crt        = var.failure_thresh_crt
  failure_thresh_duration   = var.failure_thresh_duration
  enable_APM_db_check       = var.enable_APM_db_check
  db_resp_time_thresh       = var.db_resp_time_thresh
  db_type                   = var.db_type
  db_transaction_type       = var.db_transaction_type
  enable_APM_apdex_check    = var.enable_APM_apdex_check
  apdex_thresh_crt          = var.apdex_thresh
  failure_aggr_delay        = var.failure_aggr_delay
  failure_aggr_method       = var.failure_aggr_method
  failure_aggr_window       = var.failure_aggr_window
  failure_aggr_timer        = var.failure_aggr_timer
  failure_slide_by          = var.failure_slide_by
}
