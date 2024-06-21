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
  high_cpu_usage_percent = var.high_cpu_usage_percent
}

# alert
module "java-microservice" {
  source           = "../java-microservice"
  alert_policy_id  = newrelic_alert_policy.lcert_app_policy.id
  enabled          = var.enabled
  complete_appname = local.complete_appname
  health_aggr_delay   = var.health_aggr_delay
  health_threshold    = var.health_threshold
  health_th_duration  = var.health_th_duration
  health_th_occurence = var.health_th_occurence
}

# APM
module "apm_v2" {
  source = "../apm_v2"

  policy_id = newrelic_alert_policy.lcert_app_policy.id
  filter_app      = "( `appName` = '${local.complete_appname}' )"
  filter_trnsct   = "( `appName` = '${local.complete_appname}' AND transactionType = 'Web' AND httpResponseCode NOT LIKE '4%' AND name != 'WebTransaction/Vertx/health/ready (GET)' )"
  enabled   = var.enabled

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


# DECK HealthCheck from ip2mvliaslci001: STATUS
resource "newrelic_nrql_alert_condition" "lcert_deck_healthcheck_result" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_app_policy.id

  name    = "Health Check on Load Balancer: STATUS"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1800
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  slide_by           = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1800
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM DECK_Sample
WHERE `STATUS` != 'OK'
AND `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // 1 check every 10 minutes
  // Alert if 3/3 consecutive checks fail within 30 min time window
  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 1800
    threshold_occurrences = "at_least_once"
  }
}

# DECK HealthCheck from ip2mvliaslci001: NO DATA
resource "newrelic_nrql_alert_condition" "lcert_deck_healthcheck_nodata" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_app_policy.id

  name    = "Health Check on Load Balancer: NO DATA"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1800
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  slide_by           = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1800
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM DECK_Sample
WHERE `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // 1 check every 10 minutes
  // Alert if no data within 30 min time window
  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 1800
    threshold_occurrences = "at_least_once"
  }
}