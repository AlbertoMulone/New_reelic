# policy
resource "newrelic_alert_policy" "lcert_cabatch_policy" {
  name = "lcert ${var.env} cabatch ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} cabatch ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_cabatch_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_cabatch_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  violation_close_timer = 72
}

//process
resource "newrelic_infra_alert_condition" "ntpd_not_running" {
  policy_id = newrelic_alert_policy.lcert_cabatch_policy.id

  name          = "ntpd not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'ntpd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "connector_not_running" {
  policy_id = newrelic_alert_policy.lcert_cabatch_policy.id

  name          = "connector not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'java'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

# nagios
resource "newrelic_nrql_alert_condition" "compliance_file_count" {
  policy_id = newrelic_alert_policy.lcert_cabatch_policy.id

  name    = "compliance_file_count"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "cadence"
  aggregation_delay  = 120

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 7200
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM NagiosServiceCheckSample
WHERE `displayName` = 'compliance_file_count'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 7200
    threshold_occurrences = "all"
  }
}

# no data
resource "newrelic_nrql_alert_condition" "cabatch_no_data" {
  policy_id = newrelic_alert_policy.lcert_cabatch_policy.id

  name    = "cabatch no data"
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
FROM NagiosServiceCheckSample
WHERE `displayName` IN ('compliance_file_count')
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `displayName`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 900
    threshold_occurrences = "all"
  }

}
