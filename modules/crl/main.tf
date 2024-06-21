# policy
resource "newrelic_alert_policy" "lcert_crl_policy" {
  name = "lcert ${var.env} crl policy"

  incident_preference = "PER_CONDITION"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} crl"
  policy_id    = newrelic_alert_policy.lcert_crl_policy.id
  notification = var.notification
}

# crl checks
resource "newrelic_nrql_alert_condition" "crl_check" {
  for_each = toset(var.crl_info)

  policy_id = newrelic_alert_policy.lcert_crl_policy.id

  name    = "crl check ${each.value}"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 6000
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 6000
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM CRLSample
WHERE `FILE` = '${each.value}.input'
AND (`CRL_STATUS` != 'OK'
OR `CA_STATUS` != 'OK')
FACET `FILE`, `DESC`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // 1 check every 30m
  // error when 3/3 in 100m window
  critical {
    operator              = "above"
    threshold             = "2"
    threshold_duration    = 6000
    threshold_occurrences = "at_least_once"
  }
}

# no data
resource "newrelic_nrql_alert_condition" "crl_no_data" {
  policy_id = newrelic_alert_policy.lcert_crl_policy.id

  name    = "crl no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 7200
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60

  violation_time_limit_seconds = 2592000
  expiration_duration          = 7200
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM CRLSample
WHERE `FILE` IN ('${join("', '", formatlist("%s.input", var.crl_info))}')
FACET `FILE`, `DESC`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 7200
    threshold_occurrences = "at_least_once"
  }
}
