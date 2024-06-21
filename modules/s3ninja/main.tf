# policy
resource "newrelic_alert_policy" "lcert_s3ninja_policy" {
  name = "lcert ${var.env} s3ninja ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} s3ninja ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_s3ninja_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_s3ninja_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  violation_close_timer   = 72
}

resource "newrelic_nrql_alert_condition" "s3ninja_container_not_running" {
  policy_id = newrelic_alert_policy.lcert_s3ninja_policy.id

  name    = "s3ninja container not running"
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
SELECT COUNT(*) 
FROM ContainerSample 
WHERE `environment` IN ('${join("', '", var.network_envs)}') 
AND `service_name` = '${var.service_name}' 
AND `name` = '${var.service_name}' 
AND `state` != 'running'    
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`, `name`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

resource "newrelic_nrql_alert_condition" "s3ninja_container_no_data" {
  policy_id = newrelic_alert_policy.lcert_s3ninja_policy.id

  name    = "s3ninja container no data"
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
SELECT COUNT(*) 
FROM ContainerSample 
WHERE `environment` IN ('${join("', '", var.network_envs)}') 
AND `service_name` = '${var.service_name}' 
AND `name` = '${var.service_name}'
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`, `name`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 900
    threshold_occurrences = "all"
  }
}
