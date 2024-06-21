# policy
resource "newrelic_alert_policy" "lcert_carpediem_policy" {
  name = "lcert ${var.env} carpediem ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} carpediem ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_carpediem_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  high_cpu_usage_duration = 30 // timestampExport sometime exceed 15m
  violation_close_timer   = 72
}

# process
resource "newrelic_infra_alert_condition" "logd_not_running" {
  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name          = "logd not running (/opt/cdie/x/sbin/logd)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '/opt/cdie/x/sbin/logd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "authd_not_running" {
  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name          = "authd not running (/opt/cdie/x/sbin/authd)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '/opt/cdie/x/sbin/authd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "tspd_not_running" {
  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name          = "tspd not running (/opt/cdie/x/sbin/tspd)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '/opt/cdie/x/sbin/tspd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "ntpd_not_running" {
  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

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
  count = var.enable_nagios || !var.enable_health ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

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
  count = var.enable_nagios || !var.enable_health ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

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
FROM CarpeDiemSample
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

resource "newrelic_nrql_alert_condition" "check_carpediem_log_flex" {
  count = var.enable_nagios ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name    = "carpediem log error"
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
FROM CarpeDiemSample
WHERE `rc` != 0 AND `rc` != 1
AND `displayName` = 'carpediem_log'
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
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

resource "newrelic_nrql_alert_condition" "check_timestamp_flex" {
  count = var.enable_nagios ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name    = "carpediem check marca"
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
FROM CarpeDiemSample
WHERE `rc` != 0 AND `rc` != 1
AND `displayName` = 'timestamp'
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

resource "newrelic_nrql_alert_condition" "check_expire_keys_flex" {
  count = var.enable_nagios ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name    = "carpediem expire keys"
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
FROM CarpeDiemSample
WHERE `rc` != 0 AND `rc` != 1
AND `displayName` = 'expire_keys'
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

resource "newrelic_nrql_alert_condition" "compliance_timestamp_error_flex" {
  count = var.enable_nagios || !var.enable_compliance ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name    = "compliance timestamp error"
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
FROM CarpeDiemSample
WHERE `result` != 'OK'
AND `displayName` = 'compliance_timestamp'
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
resource "newrelic_nrql_alert_condition" "carpediem_no_data_flex" {
  count = var.enable_nagios ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name    = "carpediem no data"
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
FROM CarpeDiemSample
WHERE `displayName` IN ('health', 'carpediem_log', 'timestamp', 'expire_keys', 'compliance_timestamp')
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
resource "newrelic_nrql_alert_condition" "check_carpediem_log" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name    = "carpediem log error"
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
WHERE `displayName` = 'carpediem_log'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
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

resource "newrelic_nrql_alert_condition" "check_timestamp" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name    = "carpediem check marca"
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
WHERE `displayName` = 'timestamp'
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

resource "newrelic_nrql_alert_condition" "check_expire_keys" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name    = "carpediem expire keys"
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
WHERE `displayName` = 'expire_keys'
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

# no data
resource "newrelic_nrql_alert_condition" "carpediem_no_data" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_carpediem_policy.id

  name    = "carpediem no data"
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
WHERE `displayName` IN ('carpediem_log', 'timestamp', 'expire_keys')
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
