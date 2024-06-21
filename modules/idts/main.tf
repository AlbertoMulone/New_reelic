# variables
locals {
  complete_appname = "${var.basename}_${var.label}_${var.env}"
}

resource "newrelic_alert_policy" "lcert_idts_policy" {
  name = "lcert ${var.env} ${var.basename} ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ${var.basename} ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_idts_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source    = "../infra"
  policy_id = newrelic_alert_policy.lcert_idts_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled
}

# APM
module "apm_v2" {
  source = "../apm_v2"

  policy_id     = newrelic_alert_policy.lcert_idts_policy.id
  filter_app    = "( `appName` = '${var.app_name}' )"
  filter_trnsct = "( `appName` = '${var.app_name}' AND `transactionType` = 'Web'  AND `httpResponseCode` NOT LIKE '4%' AND `name` != 'WebTransaction/Servlet/it.infocert.legalcert.idts.rest.application.IdtsRestInterface' AND `httpResponseCode` IS NOT NULL)"
  enabled       = var.enabled

  enable_APM_duration_check = var.enable_APM_duration_check
  duration_thresh_crt       = var.duration_thresh_crt
  enable_APM_db_check       = var.enable_APM_db_check
  db_resp_time_thresh       = var.db_resp_time_thresh
  db_type                   = var.db_type
  db_transaction_type       = var.db_transaction_type
  enable_APM_failure_check  = var.enable_APM_failure_check
  failure_thresh_crt        = var.failure_thresh_crt
  failure_thresh_duration   = var.failure_thresh_duration
  failure_aggr_delay        = var.failure_aggr_delay
  failure_aggr_method       = var.failure_aggr_method
  failure_aggr_timer        = var.failure_aggr_timer
  failure_slide_by          = var.failure_slide_by
}

# idts status
resource "newrelic_nrql_alert_condition" "idts_status_check" {
  policy_id = newrelic_alert_policy.lcert_idts_policy.id

  name    = "idts status check"
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
WHERE `displayName` = 'jboss_status_idts'
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

# idts memory
resource "newrelic_nrql_alert_condition" "idts_heap_check" {
  policy_id = newrelic_alert_policy.lcert_idts_policy.id

  name    = "idts heap check"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 900
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM NagiosServiceCheckSample
WHERE `displayName` = 'jboss_memory_idts'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 900
    threshold_occurrences = "all"
  }
}

# idts thread
resource "newrelic_nrql_alert_condition" "idts_thread_check" {
  policy_id = newrelic_alert_policy.lcert_idts_policy.id

  name    = "idts thread check"
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
WHERE `displayName` = 'jboss_thread_idts'
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

# idts dataSource
resource "newrelic_nrql_alert_condition" "idts_datasource_check" {
  policy_id = newrelic_alert_policy.lcert_idts_policy.id

  name    = "idts datasource check"
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
WHERE `displayName` = 'jboss_datasource_idts'
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
resource "newrelic_nrql_alert_condition" "idts_nagios_no_data_error" {
  policy_id = newrelic_alert_policy.lcert_idts_policy.id

  name    = "idts nagios no data error"
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
WHERE `displayName` in ('jboss_datasource_idts', 'jboss_memory_idts', 'jboss_thread_idts', 'jboss_datasource_idts')
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `displayName`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 900
    threshold_occurrences = "all"
  }
}

# IDTS probe checks
resource "newrelic_nrql_alert_condition" "idts_probe_check" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_idts_policy.id

  name    = "idts probe checks: PING, TIMESTAMP, ALTEPERF, MARCHE"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1200
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  slide_by           = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1200
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM IDTSSample
WHERE `STATUS` != 'OK'
AND `environment` = '${var.env}'
AND `service_name` = '${var.service_name}'
FACET `brand`, `team`, `environment`, `technical_service`
EOF

  }
  // 1 check every 5 minutes
  // Alert if 3/3 consecutive checks fail within 20 min time window
  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}

# IDTS probe no data
resource "newrelic_nrql_alert_condition" "idts_probe_no_data" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_idts_policy.id

  name    = "idts probe no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1800
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  slide_by           = 60

  violation_time_limit_seconds = 2592000
  expiration_duration          = 1800
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM IDTSSample
WHERE `environment` = '${var.env}'
AND `service_name` = '${var.service_name}'
FACET `brand`, `team`, `environment`, `technical_service`
EOF

  }
  // No data alert if no signals received for 30 min
  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 1800
    threshold_occurrences = "at_least_once"
  }

}

# nagios inodes
resource "newrelic_nrql_alert_condition" "idts_inodes_var" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_idts_policy.id

  name    = "idts_inodes_var"
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
WHERE `displayName` = 'inodes_idts_var'
AND `serviceCheck.status` >= 2
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

resource "newrelic_nrql_alert_condition" "idts_inodes_consumi" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_idts_policy.id

  name    = "idts_inodes_consumi"
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
WHERE `displayName` = 'inodes_idts_consumi'
AND `serviceCheck.status` >= 2
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

resource "newrelic_nrql_alert_condition" "idts_inodes_consumi_sign" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_idts_policy.id

  name    = "idts_inodes_consumi_sign"
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
WHERE `displayName` = 'inodes_idts_consumi_sign'
AND `serviceCheck.status` >= 2
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

# synthetics
module "idts_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_idts_policy.id
  product   = "IDTS"
}