# variables
locals {
  complete_appname = "${var.basename}_${var.label}_${var.new_relic_env}"
}

# policy
resource "newrelic_alert_policy" "lcert_app_policy" {
  name = "lcert ${var.env} ${var.basename} ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ${var.basename} ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_app_policy.id
  notification = var.notification
}

# APM
module "apm_v2" {
  source = "../apm_v2"

  policy_id     = newrelic_alert_policy.lcert_app_policy.id
  filter_app    = "( `appName` = '${local.complete_appname}' )"
  filter_trnsct = "( `appName` = '${local.complete_appname}' AND `transactionType` = 'Web' AND `httpResponseCode` NOT LIKE '4%' AND `name` != 'WebTransaction/Vertx/health/live (GET)' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' )"
  enabled       = var.enabled

  enable_APM_duration_check = var.enable_APM_duration_check
  enable_APM_failure_check  = var.enable_APM_failure_check
  failure_thresh_crt        = var.failure_thresh_crt
  failure_thresh_duration   = var.failure_thresh_duration
  enable_APM_apdex_check    = var.enable_APM_apdex_check
  apdex_thresh_crt          = var.apdex_thresh_check
}

# synthetics
module "mytriss_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_app_policy.id
  product   = var.basename
}