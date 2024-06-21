# policy
resource "newrelic_alert_policy" "lcert_ocsp_policy" {
  name = "lcert ${var.env} ocsp ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ocsp ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_ocsp_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_ocsp_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  violation_close_timer     = 72
  enable_fs_read_only       = true
  enable_host_not_reporting = length(regexall(".aws", var.env)) > 0 ? false : true
}

# process
resource "newrelic_infra_alert_condition" "ocspd_not_running" {
  policy_id = newrelic_alert_policy.lcert_ocsp_policy.id

  name          = "ocspd not running (/opt/ocsp/x/sbin/ocspd)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '/opt/ocsp/x/sbin/ocspd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "ntpd_not_running" {
  policy_id = newrelic_alert_policy.lcert_ocsp_policy.id

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

resource "newrelic_infra_alert_condition" "chronyd_not_running" {
  count = length(regexall(".aws", var.env)) > 0 ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_ocsp_policy.id

  name          = "chronyd not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'chronyd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

# flex
resource "newrelic_nrql_alert_condition" "check_expire_certs" {
  policy_id = newrelic_alert_policy.lcert_ocsp_policy.id

  name    = "check expire certs"
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
FROM OCSPSample
WHERE `rc` != 0 AND `rc` != 1
AND `displayName` = 'check_expire_certs'
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

resource "newrelic_nrql_alert_condition" "check_local" {
  policy_id = newrelic_alert_policy.lcert_ocsp_policy.id

  name    = "check local"
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
FROM OCSPSample
WHERE `rc` != 0 AND `rc` != 1
AND `displayName` = 'check_local'
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

resource "newrelic_nrql_alert_condition" "check_balancer" {
  policy_id = newrelic_alert_policy.lcert_ocsp_policy.id

  name    = "check balancer"
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
FROM OCSPSample
WHERE `rc` != 0 AND `rc` != 1
AND `displayName` = 'check_balancer'
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
resource "newrelic_nrql_alert_condition" "ocsp_no_data" {
  policy_id = newrelic_alert_policy.lcert_ocsp_policy.id

  name    = "ocsp no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "cadence"
  aggregation_delay  = 120

  violation_time_limit_seconds = 2592000
  expiration_duration          = 1800
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM OCSPSample
WHERE `displayName` IN ('check_expire_certs', 'check_local', 'check_balancer')
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `displayName`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 1800
    threshold_occurrences = "all"
  }
}
