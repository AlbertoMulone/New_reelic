# APDEX
resource "newrelic_nrql_alert_condition" "APM_check_APDEX" {
  count = var.enable_APM_apdex_check ? 1 : 0

  policy_id = var.policy_id

  name    = "APM: APDEX score < ${var.apdex_thresh_crt}"
  type    = "static"
  enabled = var.enable_APM_apdex_check

  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120

  violation_time_limit_seconds = 2592000

  nrql {
    query = <<EOF
SELECT filter(apdex(newrelic.timeslice.value), where `metricTimesliceName` = 'Apdex')
AS 'APDEX'
FROM Metric
WHERE ${var.filter_app}
FACET `tags.team`, `tags.brand`, `tags.technical_service`, `tags.environment`
EOF

  }

  critical {
    operator              = "below"
    threshold             = var.apdex_thresh_crt
    threshold_duration    = var.apdex_thresh_duration  //var.enable_APM_apdex_check ? 480 : 300
    threshold_occurrences = "all"
  }
}

# duration
resource "newrelic_nrql_alert_condition" "APM_check_duration" {
  count = var.enable_APM_duration_check ? 1 : 0

  policy_id = var.policy_id

  name               = "APM: slow transactions"
  type               = "baseline"
  baseline_direction = "upper_only"
  enabled            = var.enable_APM_duration_check

  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120

  violation_time_limit_seconds = 2592000

  nrql {
    query = <<EOF
SELECT filter(average(apm.service.transaction.duration), WHERE `metricName` = 'apm.service.transaction.duration')
AS 'Duration: All Transactions'
FROM Metric
WHERE ${var.filter_trnsct}
FACET `transactionName`, `tags.team`, `tags.brand`, `tags.technical_service`, `tags.environment`
EOF

  }

  critical {
    operator              = "above"
    threshold             = var.duration_thresh_crt
    threshold_duration    = var.duration_thresh_duration
    threshold_occurrences = "all"
  }
}

# failure rate
resource "newrelic_nrql_alert_condition" "APM_check_failure" {
  count = var.enable_APM_failure_check ? 1 : 0

  policy_id = var.policy_id

  name    = "APM: transactions failure rate > ${var.failure_thresh_crt}"
  type    = "static"
  enabled = var.enable_APM_failure_check

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds = 2592000

  nrql {
    query = <<EOF
SELECT filter(count(apm.service.error.count), WHERE `metricTimesliceName` = 'Errors/all') / filter(count(apm.service.transaction.duration), WHERE `metricName` = 'apm.service.transaction.duration')
AS 'Failure Rate: All Errors'
FROM Metric
WHERE ${var.filter_trnsct}
FACET `transactionName`, `tags.team`, `tags.brand`, `tags.technical_service`, `tags.environment`
EOF

  }

  critical {
    operator              = "above"
    threshold             = var.failure_thresh_crt
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "APM_check_DB_resp_time" {
  count = var.enable_APM_db_check ? 1 : 0

  policy_id = var.policy_id

  name    = "APM: ${var.db_type} response time > ${var.db_resp_time_thresh} ms"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 900
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT average(apm.service.datastore.operation.duration)*1000
FROM Metric
WHERE ${var.filter_app}
AND `datastoreType` = '${var.db_type}'
FACET `${var.db_transaction_type}`, `tags.team`, `tags.brand`, `tags.technical_service`, `tags.environment`
EOF

  }
  // error when average response time > var.db_resp_time_thresh
  critical {
    operator              = "above"
    threshold             = var.db_resp_time_thresh
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}