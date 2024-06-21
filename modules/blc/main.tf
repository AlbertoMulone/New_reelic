# variables
locals {
  complete_appname = "${var.basename}_${var.label}_${var.env}"
}

# policy
resource "newrelic_alert_policy" "lcert_blc_policy" {
  name = "lcert ${var.env} ${var.basename} ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ${var.basename} ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_blc_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source    = "../infra"
  policy_id = newrelic_alert_policy.lcert_blc_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  violation_close_timer = 72
}

# blc Sonda
resource "newrelic_nrql_alert_condition" "blc_check_sonda" {
  policy_id = newrelic_alert_policy.lcert_blc_policy.id

  name    = "blc check sonda"
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
FROM NagiosServiceCheckSample
WHERE `displayName` = 'check_sonda_blc'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

# Lei Sonda
resource "newrelic_nrql_alert_condition" "lei_check_sonda" {
  policy_id = newrelic_alert_policy.lcert_blc_policy.id

  name    = "lei check sonda"
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
FROM NagiosServiceCheckSample
WHERE `displayName` = 'check_sonda_lei'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

# blc FileNum
resource "newrelic_nrql_alert_condition" "blc_check_filenum" {
  count = var.env == "prod" ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_blc_policy.id

  name    = "blc check filenum"
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
FROM NagiosServiceCheckSample
WHERE `displayName` = 'check_blc_numoffiles'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

# Lei Expire p12
resource "newrelic_nrql_alert_condition" "lei_expire_p12" {
  policy_id = newrelic_alert_policy.lcert_blc_policy.id

  name    = "lei expire p12"
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
FROM NagiosServiceCheckSample
WHERE `displayName` = 'lei_expire_p12'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

# no data
resource "newrelic_nrql_alert_condition" "blc_no_data_error" {
  policy_id = newrelic_alert_policy.lcert_blc_policy.id

  name    = "blc no data error"
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
FROM NagiosServiceCheckSample
WHERE `displayName` IN ('check_blc_numoffiles','check_sonda_blc','check_sonda_lei','lei_expire_p12')
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
