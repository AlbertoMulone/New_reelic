# variables
resource "newrelic_alert_policy" "lcert_ncar_policy" {
  name = "lcert ${var.env} ncar infocert policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ncar infocert"
  policy_id    = newrelic_alert_policy.lcert_ncar_policy.id
  notification = var.notification
}

# NCAR: Connection Pool saturation
resource "newrelic_nrql_alert_condition" "ncar_connpool_check" {
  policy_id = newrelic_alert_policy.lcert_ncar_policy.id

  name    = "ConnectionPool saturation: JDBC/ncarDS"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 300
  aggregation_method = "event_flow"
  aggregation_delay  = 10
  slide_by           = 60
  

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 900
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT average(AvailableConnectionCount)
FROM NCAR_jdbc_ConnPool_Sample
WHERE `environment` = '${var.env}'
FACET `jvm`, `environment`, `technical_service`, `brand`, `team`
EOF

  }
  // error when avialable connections are below 20
  critical {
    operator              = "below"
    threshold             = 20
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

# NCAR: Connection Pool checks - no data
resource "newrelic_nrql_alert_condition" "ncar_connpool_check_no_data" {
  policy_id = newrelic_alert_policy.lcert_ncar_policy.id

  name    = "ConnectionPool checks - NO DATA"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 300
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  slide_by           = 60
  

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 3600
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM NCAR_jdbc_ConnPool_Sample
WHERE `environment` = '${var.env}'
FACET `jvm`, `environment`, `technical_service`, `brand`, `team`
EOF

  }
  // error when avialable connections are below 20
  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 900
    threshold_occurrences = "all"
  }
}

# synthetics
module "ncar_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_ncar_policy.id
  product   = "NCAR"
}