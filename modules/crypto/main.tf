# variables
locals {
  complete_appname       = "${var.basename}_${var.label}_${var.env}"
  appname_for_APM_checks = "${upper(var.basename)}_${var.env}"
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

/*
# alert
module "java-microservice" {
  source           = "../java-microservice"
  alert_policy_id  = newrelic_alert_policy.lcert_app_policy.id
  enabled          = var.enabled
  complete_appname = local.complete_appname
}
*/

# Java-microservice process
# [java-microservice module disabled for SIGN-1120: health check flex replaced with curl flex (see below)]
resource "newrelic_infra_alert_condition" "java_not_running" {
  policy_id = newrelic_alert_policy.lcert_app_policy.id

  name          = "no java processes running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = 'java'"
  where         = "( `apmApplicationNames` like '%|${local.complete_appname}|%' )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }

}

# curl flex health check
resource "newrelic_nrql_alert_condition" "health_response_result" {
  policy_id = newrelic_alert_policy.lcert_app_policy.id

  name    = "health check response result"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 300
  aggregation_method = "event_flow"
  aggregation_delay  = 10
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 300
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM crypto_hc
WHERE `STATUS` != 'OK'
AND `apmApplicationNames` LIKE '%|${local.complete_appname}|%'
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }
  // error when 5 consecutive errors within 5m window
  critical {
    operator              = "above"
    threshold             = "5"
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }

}

# no data
resource "newrelic_nrql_alert_condition" "health_response_result_no_data" {
  policy_id = newrelic_alert_policy.lcert_app_policy.id

  name    = "health check response result no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120

  violation_time_limit_seconds = 2592000
  expiration_duration          = 900
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM crypto_hc
WHERE `apmApplicationNames` LIKE '%|${local.complete_appname}|%'
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 900
    threshold_occurrences = "all"
  }

}

# APM
module "apm_v2" {
  source = "../apm_v2"

  policy_id     = newrelic_alert_policy.lcert_app_policy.id
  filter_app    = "( `appName` = '${local.complete_appname}' )"
  filter_trnsct = "( `appName` = '${local.complete_appname}' AND `transactionType` = 'Web' AND `name` != 'WebTransaction/Vertx/health/live (GET)' AND `name` != 'WebTransaction/Vertx/health/ready (GET)' AND `httpResponseCode` NOT LIKE '4%' )"
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
module "crypto_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_app_policy.id
  product   = "CRYPTO"
}