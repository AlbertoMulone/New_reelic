# policy
resource "newrelic_alert_policy" "lcert_newrelic_synthetics_policy" {
  name = "lcert ${var.env} newrelic policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} newrelic"
  policy_id    = newrelic_alert_policy.lcert_newrelic_synthetics_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_newrelic_synthetics_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled
}

# container
resource "newrelic_nrql_alert_condition" "minion_not_running" {
  policy_id = newrelic_alert_policy.lcert_newrelic_synthetics_policy.id

  name    = "minion not running"
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
FROM ContainerSample
WHERE `name` = '${var.minion_name}'
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}
