# policy
resource "newrelic_alert_policy" "lcert_sots_policy" {
  name = "lcert ${var.env} sots policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} sots"
  policy_id    = newrelic_alert_policy.lcert_sots_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source    = "../infra"
  policy_id = newrelic_alert_policy.lcert_sots_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  violation_close_timer = 72
}

resource "newrelic_infra_alert_condition" "sots_not_running" {
  policy_id = newrelic_alert_policy.lcert_sots_policy.id

  name          = "sots not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = 'java'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

# flex
resource "newrelic_nrql_alert_condition" "sots_tcp_6000" {
  policy_id = newrelic_alert_policy.lcert_sots_policy.id

  name    = "sots tcp 6000"
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
  FROM SOTSSample
  WHERE `rc` != 0
  AND `displayName` = 'tcp_6000'
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

resource "newrelic_nrql_alert_condition" "sots_timestamp" {
  policy_id = newrelic_alert_policy.lcert_sots_policy.id

  name    = "sots timestamp"
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
  FROM SOTSSample
  WHERE `rc` != 0
  AND `displayName` = 'timestamp'
  AND `service_name` = '${var.service_name}'
  AND `environment` IN ('${join("', '", var.network_envs)}')
  FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
  EOF
  }

  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "sots_status" {
  policy_id = newrelic_alert_policy.lcert_sots_policy.id

  name    = "sots status"
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
  FROM SOTSSample
  WHERE `rc` != 0
  AND `displayName` = 'status'
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

resource "newrelic_nrql_alert_condition" "sots_lsof" {
  policy_id = newrelic_alert_policy.lcert_sots_policy.id

  name    = "sots to many open files"
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
  FROM SOTSSample
  WHERE `result` >= 2000
  AND `displayName` = 'lsof'
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

# flex no data
resource "newrelic_nrql_alert_condition" "sots_no_data" {
  policy_id = newrelic_alert_policy.lcert_sots_policy.id

  name    = "sots no data"
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
FROM SOTSSample
WHERE `displayName` IN ('tcp_6000', 'timestamp', 'status', 'lsof')
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
