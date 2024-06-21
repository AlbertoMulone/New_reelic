# policy
resource "newrelic_alert_policy" "lcert_gdc_policy" {
  name = "lcert ${var.env} gdc ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} gdc ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_gdc_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_gdc_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  violation_close_timer = 72
}


# # flex no data
resource "newrelic_nrql_alert_condition" "gdc_no_data_flex" {
  policy_id = newrelic_alert_policy.lcert_gdc_policy.id

  name    = "gdc no data"
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
FROM GdCSample
WHERE `displayName` IN ('gdc_check_application_logical_access', 'gdc_check_certificate_lifecycle', 'gdc_check_database_logical_access', 'gdc_check_direct_logical_access', 'gdc_check_hsm_logical_access', 'gdc_check_windows_logical_access', 'gdc_check_guacamole_logical_access')
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

resource "newrelic_infra_alert_condition" "crond_not_running" {
  policy_id = newrelic_alert_policy.lcert_gdc_policy.id

  name          = "crond not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'crond'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_nrql_alert_condition" "gdc_check_application_logical_access_error" {
  policy_id = newrelic_alert_policy.lcert_gdc_policy.id

  name    = "gdc check application logical access error"
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
FROM GdCSample
WHERE `result` != 'OK'
AND `displayName` = 'gdc_check_application_logical_access'
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

resource "newrelic_nrql_alert_condition" "gdc_check_certificate_lifecycle_error" {
  policy_id = newrelic_alert_policy.lcert_gdc_policy.id

  name                 = "gdc check certificate lifecycle error"
  type                 = "static"
  enabled              = var.enabled
  
  aggregation_window   = 60
  aggregation_method   = "cadence"
  aggregation_delay    = 120

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 300
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM GdCSample
WHERE `result` != 'OK'
AND `displayName` = 'gdc_check_certificate_lifecycle'
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

resource "newrelic_nrql_alert_condition" "gdc_check_database_logical_access_error" {
  policy_id = newrelic_alert_policy.lcert_gdc_policy.id

  name    = "gdc check database logical access error"
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
FROM GdCSample
WHERE `result` != 'OK'
AND `displayName` = 'gdc_check_database_logical_access'
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

resource "newrelic_nrql_alert_condition" "gdc_check_direct_logical_access_error" {
  policy_id = newrelic_alert_policy.lcert_gdc_policy.id

  name    = "gdc check direct logical access error"
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
FROM GdCSample
WHERE `result` != 'OK'
AND `displayName` = 'gdc_check_direct_logical_access'
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

resource "newrelic_nrql_alert_condition" "gdc_check_hsm_logical_access_error" {
  policy_id = newrelic_alert_policy.lcert_gdc_policy.id

  name    = "gdc check hsm logical access error"
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
FROM GdCSample
WHERE `result` != 'OK'
AND `displayName` = 'gdc_check_hsm_logical_access'
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

resource "newrelic_nrql_alert_condition" "gdc_check_windows_logical_access_error" {
  policy_id = newrelic_alert_policy.lcert_gdc_policy.id

  name    = "gdc check windows logical access error"
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
FROM GdCSample
WHERE `result` != 'OK'
AND `displayName` = 'gdc_check_windows_logical_access'
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

resource "newrelic_nrql_alert_condition" "gdc_check_guacamole_logical_access_error" {
  policy_id = newrelic_alert_policy.lcert_gdc_policy.id

  name    = "gdc check guacamole logical access error"
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
FROM GdCSample
WHERE `result` != 'OK'
AND `displayName` = 'gdc_check_guacamole_logical_access'
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

resource "newrelic_nrql_alert_condition" "gdc_check_dc_physical_access_error" {
  policy_id = newrelic_alert_policy.lcert_gdc_policy.id

  name    = "gdc check dc physical access error"
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
FROM GdCSample
WHERE `result` != 'OK'
AND `displayName` = 'gdc_check_dc_physical_access'
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
