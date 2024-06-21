# policy
resource "newrelic_alert_policy" "pub_lcert_isp_crl_policy" {
  name = "PUB | lcert ${var.env} isp crl policy"
}

resource "newrelic_nrql_alert_condition" "lcert_isp_crl_checks" {
  policy_id = newrelic_alert_policy.pub_lcert_isp_crl_policy.id

  name    = "isp ca2 crl checks"
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
WHERE `FILE` = 'IntesaSanpaoloFQ2.input' 
AND (`CRL_STATUS` = 'KO: CRL scaduta' OR `CA_STATUS` != 'OK')
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

resource "newrelic_nrql_alert_condition" "lcert_isp_ii_crl_checks" {
  policy_id = newrelic_alert_policy.pub_lcert_isp_crl_policy.id

  name    = "isp ii crl checks"
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
WHERE `FILE` = 'IntesaSanpaoloIdenTrust.input' 
AND (`CRL_STATUS` = 'KO: CRL scaduta' OR `CA_STATUS` != 'OK')
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
