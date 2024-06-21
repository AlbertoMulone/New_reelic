# variables
locals {
  complete_appname = "${var.basename}_${var.label}_${var.env}"
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

# infra
module "infra" {
  source    = "../infra"
  policy_id = newrelic_alert_policy.lcert_app_policy.id
  filter    = "( `apmApplicationNames` like '%|${local.complete_appname}|%' )"
  enabled   = var.enabled
}

# alert
module "java-microservice" {
  source           = "../java-microservice"
  alert_policy_id  = newrelic_alert_policy.lcert_app_policy.id
  enabled          = var.enabled
  complete_appname = local.complete_appname
  health_aggr_delay   = 10
  health_threshold    = 4
  health_th_duration  = 300
  health_th_occurence = "at_least_once"
}

# APM
module "apm_v2" {
  source = "../apm_v2"

  policy_id     = newrelic_alert_policy.lcert_app_policy.id
  filter_app    = "( `appName` = '${local.complete_appname}' )"
  filter_trnsct = "( `appName` = '${local.complete_appname}' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' AND `name` != 'WebTransaction/Vertx/health/live (GET)'AND `httpResponseCode` NOT LIKE '4%' )"
  enabled       = var.enabled

  enable_APM_duration_check = var.enable_APM_duration_check
  enable_APM_failure_check  = var.enable_APM_failure_check
  failure_thresh_crt        = var.failure_thresh_crt
  failure_thresh_duration   = var.failure_thresh_duration
  failure_slide_by          = var.failure_slide_by
  enable_APM_db_check       = var.enable_APM_db_check
  db_resp_time_thresh       = var.db_resp_time_thresh
  db_type                   = var.db_type
  db_transaction_type       = var.db_transaction_type
}

# synthetics
module "triss_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_app_policy.id
  product   = "TRISS"
}