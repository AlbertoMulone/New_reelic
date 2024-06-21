# policy
resource "newrelic_alert_policy" "pub_lcert_isp_ocsp_policy" {
  name = "PUB | lcert ${var.env} isp ocsp policy"
}

resource "newrelic_nrql_alert_condition" "lcert_isp_ocsp_checks" {
  policy_id = newrelic_alert_policy.pub_lcert_isp_ocsp_policy.id

  name    = "isp ca2 ocsp checks"
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
FROM OGRESample
WHERE `rc` != 0 AND `rc` != 1 
AND `displayName` = 'check_balancer' 
AND `service_name` = 'ogre2isp' 
AND `environment` IN ('praws')
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

# resource "newrelic_nrql_alert_condition" "lcert_isp_ii_ocsp_checks" {
#   policy_id = newrelic_alert_policy.pub_lcert_isp_ocsp_policy.id

#   name    = "isp ii ocsp checks"
#   type    = "static"
#   enabled = var.enabled

#   aggregation_window = 60
#   aggregation_method = "cadence"
#   aggregation_delay  = 120

#   violation_time_limit_seconds   = 2592000
#   expiration_duration            = 300
#   close_violations_on_expiration = true

#   nrql {
#     query = <<EOF
# SELECT count(*)
# FROM NagiosRemoteCheckSample
# WHERE `nagios.check` = 'check_va'
# AND `nagios.rc` >= 2
# AND `nagios.service_name` = 'ocspii'
# AND `nagios.environment` IN ('prdmz')
# EOF
#   }

#   critical {
#     operator              = "above"
#     threshold             = "0"
#     threshold_duration    = 300
#     threshold_occurrences = "all"
#   }
# }
