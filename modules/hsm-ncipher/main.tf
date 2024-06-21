# policy
resource "newrelic_alert_policy" "lcert_hsm_ncipher_policy" {
  name = "lcert ${var.env} hsm ncipher ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} hsm ncipher ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_hsm_ncipher_policy.id
  notification = var.notification
}

# alert
resource "newrelic_nrql_alert_condition" "hsm_ncipher_mode_not_operational" {
  policy_id = newrelic_alert_policy.lcert_hsm_ncipher_policy.id

  name    = "hsm_ncipher_mode_not_operational"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "cadence"
  aggregation_delay  = 120

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 300
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM HSMnCipherSample
WHERE `mode` != 1
AND `label.hsm` IN ('${join("', '", var.hsms)}')
FACET `label.hsm`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "hsm_ncipher_temperature_error" {
  policy_id = newrelic_alert_policy.lcert_hsm_ncipher_policy.id

  name    = "hsm_ncipher_temperature_error"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "cadence"
  aggregation_delay  = 120

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 3600
  close_violations_on_expiration = true

  # TODO temp remove 37
  # WHERE `temperature` rlike '(37|38|39|4\\d|5\\d|6\\d|7\\d|8\\d|9\\d).\\d degrees C'
  nrql {
    query = <<EOF
SELECT count(*)
FROM HSMnCipherSample
WHERE `temperature` rlike '(38|39|4\\d|5\\d|6\\d|7\\d|8\\d|9\\d).\\d degrees C'
AND `label.hsm` IN ('${join("', '", var.hsms)}')
FACET `label.hsm`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 3600
    threshold_occurrences = "all"
  }
}

# no data
resource "newrelic_nrql_alert_condition" "hsm_ncipher_no_data_error" {
  policy_id = newrelic_alert_policy.lcert_hsm_ncipher_policy.id

  name    = "hsm ncipher no data error"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "cadence"
  aggregation_delay  = 120

  violation_time_limit_seconds = 2592000
  expiration_duration          = 3600
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM HSMnCipherSample
WHERE `label.hsm` IN ('${join("', '", var.hsms)}')
FACET `label.hsm`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 3600
    threshold_occurrences = "all"
  }
}
