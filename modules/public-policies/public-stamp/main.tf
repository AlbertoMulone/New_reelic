# policy
resource "newrelic_alert_policy" "pub_lcert_stamp_policy" {
  name = "PUB | lcert ${var.env} stamp policy"
}

# STAMP Milan probe checks
resource "newrelic_nrql_alert_condition" "lcert_stamp_probe_checks" {
  policy_id = newrelic_alert_policy.pub_lcert_stamp_policy.id

  name    = "stamp Milan probe checks: PING  TIMESTAMPS  MARCHE"
  type    = "static"
  enabled = var.enabled

  //value_function   = "sum"
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
SELECT count(*)
FROM STAMP_Sample
WHERE `TS_USER_INT` != 'TS User Int OK'
AND `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF


  }
  // 1 check every 5 minutes
  // Alert if 3/3 consecutive checks fail within 20 min time window
  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}