# policy
resource "newrelic_alert_policy" "lcert_bridge_policy" {
  name = "lcert ${var.env} bridge infocert policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} bridge infocert"
  policy_id    = newrelic_alert_policy.lcert_bridge_policy.id
  notification = var.notification
}

# BRIDGE health check
resource "newrelic_nrql_alert_condition" "lcert_bridge_hc_status" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_bridge_policy.id

  name    = "HC probe: /deck-rest/authorization/user"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1800
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  slide_by           = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 2400
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM BRIDGE_Sample
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

# BRIDGE healthcheck no data
resource "newrelic_nrql_alert_condition" "lcert_bridge_hc_nodata" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_bridge_policy.id

  name    = "HC probe: no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1800
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  slide_by           = 60

  violation_time_limit_seconds = 2592000
  expiration_duration          = 1800
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM BRIDGE_Sample
WHERE `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // No data alert if no signals received for 30 min
  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 1800
    threshold_occurrences = "all"
  }

}