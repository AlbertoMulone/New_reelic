# policy
resource "newrelic_alert_policy" "lcert_radius_policy" {
  name = "lcert ${var.env} radius policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} radius"
  policy_id    = newrelic_alert_policy.lcert_radius_policy.id
  notification = var.notification
}

# nagios
resource "newrelic_nrql_alert_condition" "nagios" {
  for_each = toset(var.nagios_checks)

  policy_id = newrelic_alert_policy.lcert_radius_policy.id

  name    = each.value
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60

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

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

# no data
resource "newrelic_nrql_alert_condition" "radius_no_data" {
  policy_id = newrelic_alert_policy.lcert_radius_policy.id

  name    = "radius no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_flow"
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
