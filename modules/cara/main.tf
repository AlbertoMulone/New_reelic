# policy
resource "newrelic_alert_policy" "lcert_cara_policy" {
  name                = "lcert ${var.env} cara policy"
  incident_preference = "PER_CONDITION"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} cara"
  policy_id    = newrelic_alert_policy.lcert_cara_policy.id
  notification = var.notification
}

# checks
resource "newrelic_nrql_alert_condition" "lcert_cara_check" {
  for_each = var.enable_checks ? var.db_monitor_info : {}

  policy_id = newrelic_alert_policy.lcert_cara_policy.id

  name    = "${each.value.product} buste ${each.value.service_name} < ${each.value.thresh_crt}"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 2400
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT latest(result)
FROM CARASQLCheck
WHERE `displayName` = '${each.value.service_name}'
FACET `displayName`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "below"
    threshold             = each.value.thresh_crt
    threshold_duration    = 2400
    threshold_occurrences = "at_least_once"
  }

}

# no data
resource "newrelic_nrql_alert_condition" "lcert_cara_no_data" {
  policy_id = newrelic_alert_policy.lcert_cara_policy.id

  name           = "cara no data"
  type           = "static"
  enabled        = var.enabled

  aggregation_window = 3600
  aggregation_method = "event_flow"
  aggregation_delay  = 120

  violation_time_limit_seconds = 2592000
  expiration_duration          = 3600
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM CARASQLCheck
WHERE `displayName` IN ('${join("', '", values(var.db_monitor_info)[*].service_name)}')
FACET `displayName`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 3600
    threshold_occurrences = "at_least_once"
  }

}
