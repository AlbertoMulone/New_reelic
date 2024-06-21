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

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_caweb_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  violation_close_timer   = 72
  enable_disk_inode_usage = true
  // TODO risolvere problema riavvio CAPF
  enable_high_cpu_usage = var.enable_high_cpu_usage
}

// process
resource "newrelic_infra_alert_condition" "capf_not_running" {
  policy_id = newrelic_alert_policy.lcert_caweb_policy.id

  name          = "capf not running"
  type          = "infra_process_running"
  comparison    = "below"
  process_where = "`commandName` = 'java'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = var.capf_proc_num
  }
}

# nagios
resource "newrelic_nrql_alert_condition" "capf_server_log" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_caweb_policy.id

  name    = "capf_server_log"
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
WHERE `displayName` = 'capf_server_log'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // error when 3 in 5m window
  critical {
    operator              = "above"
    threshold             = "2"
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "capf_errore_emissione_signacert" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_caweb_policy.id

  name    = "capf_errore_emissione_signacert"
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
WHERE `displayName` = 'capf_errore_emissione_signacert'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // error when 3 in 5m window
  critical {
    operator              = "above"
    threshold             = "2"
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "capf_errore_emissione_unicert" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_caweb_policy.id

  name    = "capf_errore_emissione_unicert"
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
WHERE `displayName` = 'capf_errore_emissione_unicert'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // error when 3 in 5m window
  critical {
    operator              = "above"
    threshold             = "2"
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "capf_errore_revoca_unicert" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_caweb_policy.id

  name    = "capf_errore_revoca_unicert"
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
WHERE `displayName` = 'capf_errore_revoca_unicert'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // error when 3 in 5m window
  critical {
    operator              = "above"
    threshold             = "2"
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "capf_unicert_probe" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_caweb_policy.id

  name    = "capf_unicert_probe"
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
WHERE `displayName` = 'capf_unicert_probe'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // error when 3 in 5m window
  critical {
    operator              = "above"
    threshold             = "2"
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "capf_expire_signarao" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_caweb_policy.id

  name    = "capf_expire_signarao"
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
WHERE `displayName` = 'capf_expire_signarao'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  // error when 3 in 5m window
  critical {
    operator              = "above"
    threshold             = "2"
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "compliance_data_log" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_caweb_policy.id

  name    = "compliance_data_log"
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
WHERE `displayName` = 'compliance_data_log'
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
resource "newrelic_nrql_alert_condition" "caweb_no_data" {
  count = var.enable_nagios ? 1 : 0

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
FROM NagiosServiceCheckSample
WHERE `displayName` IN ('capf_server_log',
                        'capf_errore_emissione_signacert',
                        'capf_errore_emissione_unicert',
                        'capf_errore_revoca_unicert',
                        'capf_unicert_probe',
                        'capf_expire_signarao',
                        'compliance_data_log')
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
