# policy
resource "newrelic_alert_policy" "lcert_cert_policy" {
  name = "lcert ${var.env} ${var.basename} ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ${var.basename} ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_cert_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source    = "../infra"
  policy_id = newrelic_alert_policy.lcert_cert_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled
  // TODO aggiungerere muting rules schedulate 0:00 - 5:00 cpu per batch legalcert
  high_cpu_usage_duration = var.batch_vm ? 240 : 15
}

resource "newrelic_nrql_alert_condition" "jboss_check" {
  for_each = toset(var.instances)

  policy_id = newrelic_alert_policy.lcert_cert_policy.id

  name    = "jboss_${each.key} check"
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
  WHERE `displayName` = 'jboss_${each.key}'
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

resource "newrelic_nrql_alert_condition" "jboss_OutOfMemoryError_check" {
  for_each = toset(var.instances)

  policy_id = newrelic_alert_policy.lcert_cert_policy.id

  name    = "jboss_${each.key} OutOfMemoryError check"
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
WHERE `displayName` = 'OutOfMemoryError_${each.key}'
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

resource "newrelic_nrql_alert_condition" "jboss_TooManyOpenFiles_check" {
  for_each = toset(var.instances)

  policy_id = newrelic_alert_policy.lcert_cert_policy.id

  name    = "jboss_${each.key} TooManyOpenFiles check"
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
WHERE `displayName` = 'TooManyOpenFiles_${each.key}'
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

resource "newrelic_nrql_alert_condition" "jboss_mem_thread_check" {
  for_each = var.env == "prod" ? toset(var.instances) : toset([])

  policy_id = newrelic_alert_policy.lcert_cert_policy.id

  name    = "jboss_${each.key} mem_thread check"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1800
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM NagiosServiceCheckSample
WHERE `displayName` = 'mem_thread_${each.key}'
AND `serviceCheck.status` >= 2
AND `service_name` = '${var.service_name}'
AND `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 1800
    threshold_occurrences = "all"
  }
}

# no data
resource "newrelic_nrql_alert_condition" "jboss_check_no_data" {
  for_each = toset(var.instances)

  policy_id = newrelic_alert_policy.lcert_cert_policy.id

  name    = "jboss_${each.key} check no data"
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
WHERE `displayName` IN ('jboss_${each.key}', 'OutOfMemoryError_${each.key}', 'TooManyOpenFiles_${each.key}', 'mem_thread_${each.key}')
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
