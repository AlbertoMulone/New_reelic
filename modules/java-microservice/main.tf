# process
resource "newrelic_infra_alert_condition" "java_not_running" {
  policy_id = var.alert_policy_id

  name          = "no java processes running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = 'java'"
  where         = "( `apmApplicationNames` like '%|${var.complete_appname}|%' )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }

}

# health
resource "newrelic_nrql_alert_condition" "health_response_result" {
  policy_id = var.alert_policy_id

  name    = "health check response result"
  type    = "static"
  enabled = var.enabled

  aggregation_window = var.health_aggr_window
  aggregation_method = var.health_aggr_method
  aggregation_timer  = var.health_aggr_timer
  aggregation_delay  = var.health_aggr_delay
  fill_option        = var.health_fill_option

  violation_time_limit_seconds   = 2592000
  expiration_duration            = var.health_exp_duration
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM MicroserviceHealth
WHERE `status` != 'UP'
AND `apmApplicationNames` LIKE '%|${var.complete_appname}|%'
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = var.health_threshold
    threshold_duration    = var.health_th_duration
    threshold_occurrences = var.health_th_occurence
  }

}

# no data
resource "newrelic_nrql_alert_condition" "health_response_result_no_data" {
  policy_id = var.alert_policy_id

  name    = "health check response result no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = var.nodata_aggr_window
  aggregation_method = "event_flow"
  aggregation_delay  = 120

  violation_time_limit_seconds = 2592000
  expiration_duration          = 900
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM MicroserviceHealth
WHERE `apmApplicationNames` LIKE '%|${var.complete_appname}|%'
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
