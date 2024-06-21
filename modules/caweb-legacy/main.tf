# policy
resource "newrelic_alert_policy" "lcert_caweb_policy" {
  name = "lcert ${var.env} caweb ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} caweb ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_caweb_policy.id
  notification = var.notification
}

# nagios
resource "newrelic_nrql_alert_condition" "nagios" {
  for_each = toset(var.nagios_checks)

  policy_id = newrelic_alert_policy.lcert_caweb_policy.id

  name    = each.value
  type    = "static"
  enabled = var.enabled

  aggregation_window = 300
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 300
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM NagiosRemoteCheckSample
WHERE `nagios.check` = '${each.value}'
AND `nagios.rc` >= 2
AND `nagios.service_name` = '${var.service_name}'
AND `nagios.environment` IN ('${join("', '", var.network_envs)}')
FACET `nagios.vm` as fullHostname,
      `nagios.brand` as brand,
      `nagios.team` as team,
      `nagios.environment` as environment,
      `nagios.technical_service` as technical_service
EOF
  }

  // 1 check every 1m
  // error when 3 in 5m window
  critical {
    operator              = "above"
    threshold             = "2"
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}

# no data
resource "newrelic_nrql_alert_condition" "caweb_no_data" {
  policy_id = newrelic_alert_policy.lcert_caweb_policy.id

  name    = "caweb no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "cadence"
  aggregation_delay  = 120

  violation_time_limit_seconds = 2592000
  expiration_duration          = 900
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM NagiosRemoteCheckSample
WHERE `nagios.check` IN ('${join("', '", var.nagios_checks)}')
AND `nagios.service_name` = '${var.service_name}'
AND `nagios.environment` IN ('${join("', '", var.network_envs)}')
FACET `nagios.vm` as fullHostname,
      `nagios.check` as displayName,
      `nagios.brand` as brand,
      `nagios.team` as team,
      `nagios.environment` as environment,
      `nagios.technical_service` as technical_service
EOF
  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 900
    threshold_occurrences = "all"
  }

}
