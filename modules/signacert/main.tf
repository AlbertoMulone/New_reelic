# policy
resource "newrelic_alert_policy" "lcert_signacert_policy" {
  name = "lcert ${var.env} signacert ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} signacert ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_signacert_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  violation_close_timer = 72
}

# process
resource "newrelic_infra_alert_condition" "logd_not_running" {
  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name          = "logd not running (/opt/sice/x/sbin/logd)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '/opt/sice/x/sbin/logd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "authd_not_running" {
  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name          = "authd not running (/opt/sice/x/sbin/authd)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '/opt/sice/x/sbin/authd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "certd_not_running" {
  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name          = "certd not running (/opt/sice/x/sbin/certd)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '/opt/sice/x/sbin/certd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "pkixd_not_running" {
  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name          = "pkixd not running (/opt/sice/x/sbin/pkixd)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '/opt/sice/x/sbin/pkixd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "ntpd_not_running" {
  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name          = "${var.ntp_type} not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = '${var.ntp_type}'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

# health
resource "newrelic_infra_alert_condition" "health_not_running" {
  count = var.enable_nagios ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name          = "health not running (/opt/health/health)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '/opt/health/health'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

# flex
resource "newrelic_nrql_alert_condition" "health_response_error" {
  count = var.enable_nagios ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name    = "health response error"
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
FROM SignaCertSample
WHERE `rc` != 0
AND `displayName` = 'health'
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "check_signacert_log_flex" {
  count = var.enable_nagios ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name    = "signacert log error"
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
FROM SignaCertSample
WHERE `rc` != 0 AND `rc` != 1
AND `context_error` != 'context deadline exceeded'
AND `displayName` = 'signacert_log'
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // 1 check every 1m
  // error when 2 in 5m window
  critical {
    operator              = "above"
    threshold             = "1"
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "compliance_cert_error_flex" {
  count = var.enable_nagios || !var.enable_compliance ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name    = "compliance cert error"
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
FROM SignaCertSample
WHERE `result` != 'OK'
AND `displayName` = 'compliance_cert'
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "compliance_crl_error_flex" {
  count = var.enable_nagios || !var.enable_compliance ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name    = "compliance crl error"
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
FROM SignaCertSample
WHERE `result` != 'OK'
AND `displayName` = 'compliance_crl'
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

# flex no data
resource "newrelic_nrql_alert_condition" "signacert_no_data_flex" {
  count = var.enable_nagios ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name    = "signacert no data"
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
FROM SignaCertSample
WHERE `displayName` IN ('health', 'signacert_log', 'compliance_cert', 'compliance_crl')
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

# nagios
resource "newrelic_nrql_alert_condition" "check_signacert_log" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name    = "signacert log error"
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
FROM NagiosServiceCheckSample
WHERE `displayName` = 'signacert_log'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // 1 check every 1m
  // error when 2 in 5m window
  critical {
    operator              = "above"
    threshold             = "1"
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "compliance_cert_error" {
  count = var.enable_nagios && var.enable_compliance ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name    = "compliance cert error"
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
FROM NagiosServiceCheckSample
WHERE `displayName` = 'compliance_cert'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "compliance_crl_error" {
  count = var.enable_nagios && var.enable_compliance ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name    = "compliance crl error"
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
FROM NagiosServiceCheckSample
WHERE `displayName` = 'compliance_crl'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

# nagios no data
resource "newrelic_nrql_alert_condition" "signacert_no_data" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_signacert_policy.id

  name    = "signacert no data"
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
WHERE `displayName` IN ('signacert_log', 'compliance_cert', 'compliance_crl')
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
