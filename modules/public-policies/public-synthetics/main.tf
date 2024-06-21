
resource "newrelic_nrql_alert_condition" "lcert_synthetics_NRQL_check" {
  for_each = var.nrql_checks_info

  policy_id = var.alert_policy_id

  name    = "result ${each.value.product} ${each.value.label}"
  type    = "static"
  enabled = true

  aggregation_window = 1200
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1200
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` =  '${each.value.sythetic_name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }

  // 3 checks every 10m
  // error when 4/6 in 20m window
  critical {
    operator              = "above"
    threshold             = "3"
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}