# policy
resource "newrelic_alert_policy" "lcert_certssl_call_policy" {
  name = "lcert ${var.env} certssl-call ${var.domain} expire policy"
  incident_preference = "PER_CONDITION"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} certssl-call ${var.domain} expire"
  policy_id    = newrelic_alert_policy.lcert_certssl_call_policy.id
  notification = var.notification
}

## ALERTS CERTSSL
# alert
resource "newrelic_nrql_alert_condition" "certssl_call_expire_error" {
  policy_id = newrelic_alert_policy.lcert_certssl_call_policy.id

  name    = "certssl_call_expire_error"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1200
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1200
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM SSLCertificateCheck
WHERE `env` = '${var.env}'
AND `domain` = '${var.domain}'
AND `daysToExpiration` < 4
AND `daysToExpiration` != 0 ${var.p12_exp_filter_SSL}
FACET `endpoint`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // 1 check every 15m
  // error when 1 in 20m window
  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}

## ALERTS P12
# alert expiration
resource "newrelic_nrql_alert_condition" "p12_call_expire_error" {
  #for_each = var.enable_p12_check ? var.p12_checks_info : {}
  count = var.enable_p12_call_check ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_certssl_call_policy.id

  name    = "mTLS p12 expired"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1200
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000

  nrql {
    query = <<EOF
SELECT count(*)
FROM check_mTLS_p12_Sample
WHERE `environment` = '${var.env}'
AND `EXP_DAYS` < 4
AND `STATUS` = 'OK' OR `STATUS` = 'KO: CER EXP' ${var.p12_exp_filter_mTLS}
FACET `service_name`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // 1 check every 15m
  // error when 1 in 20m window
  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}
