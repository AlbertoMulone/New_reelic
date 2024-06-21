# policy
resource "newrelic_alert_policy" "lcert_atum_policy" {
  name = "lcert ${var.env_newrelic} atum policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env_newrelic} atum"
  policy_id    = newrelic_alert_policy.lcert_atum_policy.id
  notification = var.notification
}

# infra
module "k8s_infra" {
  source = "../infra-k8s"

  policy_id = newrelic_alert_policy.lcert_atum_policy.id
  filter    = "( `clusterName` = '${var.clusterName}' AND `deploymentName` = '${var.deploymentName}' )"
  enabled   = var.enabled
}

# APM
module "apm_v2" {
  source = "../apm_v2"

  policy_id     = newrelic_alert_policy.lcert_atum_policy.id
  filter_app    = "( `appName` = 'atum_infocert_${var.env_newrelic}' )"
  filter_trnsct = "( `appName` = 'atum_infocert_${var.env_newrelic}' AND transactionType = 'Web' AND httpResponseCode NOT LIKE '4%'AND name != 'WebTransaction/Vertx/atum/health/ready (GET)' AND name != 'WebTransaction/Vertx/atum/health/live (GET)' )"
  enabled       = var.enabled

  enable_APM_duration_check = var.enable_APM_duration_check
  duration_thresh_crt       = var.duration_thresh_crt
  enable_APM_db_check       = var.enable_APM_db_check
  db_resp_time_thresh       = var.db_resp_time_thresh
  db_type                   = var.db_type
  db_transaction_type       = var.db_transaction_type
  enable_APM_failure_check  = var.enable_APM_failure_check
  failure_thresh_crt        = var.failure_thresh_crt
  failure_thresh_duration   = var.failure_thresh_duration
  failure_slide_by          = var.failure_slide_by
}

# synthetics
module "atum_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_atum_policy.id
  product   = "ATUM"
}
