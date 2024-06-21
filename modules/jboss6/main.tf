# jboss status
resource "newrelic_nrql_alert_condition" "jboss_status_check" {
  for_each = toset(var.jboss_instances)

  policy_id = var.alert_policy_id

  name    = "jboss status check"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 300
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM NagiosServiceCheckSample
WHERE `serviceCheck.status` >= 2
AND `displayName` = 'jboss_${each.key}'
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

# jboss heap
resource "newrelic_nrql_alert_condition" "jboss_heap_check" {
  for_each = toset(var.jboss_instances)

  policy_id = var.alert_policy_id

  name    = "jboss heap check"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 900
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM NagiosServiceCheckSample
WHERE `serviceCheck.status` >= 2
AND `displayName` = 'jboss_heap_${each.key}'
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 900
    threshold_occurrences = "all"
  }
}

# no data
resource "newrelic_nrql_alert_condition" "jboss_no_data" {
  for_each = toset(var.jboss_instances)

  policy_id = var.alert_policy_id

  name    = "jboss no data"
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
FROM NagiosServiceCheckSample
WHERE `displayName` IN ('jboss_${each.key}', 'jboss_heap_${each.key}')
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `displayName`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 900
    threshold_occurrences = "all"
  }
}
