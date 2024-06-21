# variables
locals {
  tags = {
    brand       = "LEGALCERT"
    team        = "LegalCert"
    environment = var.env
  }
}

# policy
resource "newrelic_alert_policy" "lcert_wcrs_policy" {
  name                = "lcert ${var.env} wcrs infocert policy"
  incident_preference = "PER_CONDITION"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} wcrs"
  policy_id    = newrelic_alert_policy.lcert_wcrs_policy.id
  notification = var.notification
}

# synthetic location
data "newrelic_synthetics_private_location" "legalcert_mgmt" {
  name                      = "LegalCert MGMT"
  account_id                = 2698411
}

# synthetic location: jobmanager w/Chrome 100+
data "newrelic_synthetics_private_location" "legalcert_mgmt_jobmanager" {
  name                      = "LegalCert MGMT JobManager"
  account_id                = 2698411
}

# Scripted api monitors
resource "newrelic_synthetics_script_monitor" "lcert_wcrs_scripted_API_checks" {
  for_each = var.enable_API_checks ? var.wcrs_scripted_API_checks : {}

  status               = each.value.enabled ? "ENABLED" : "DISABLED"
  name                 = "PUB | WCRS | ${upper(var.env)} | ${each.value.label}"
  type                 = "SCRIPT_API"
  location_private    {
    guid               = data.newrelic_synthetics_private_location.legalcert_mgmt.id
  }
  period               = "EVERY_MINUTE"

  script               = templatefile("${path.module}/scripts/${each.value.script}",
    {
      url           = each.value.url
      user          = each.value.user
      pass          = each.value.pass
      code          = each.value.code
      check_string  = each.value.check_string
      authorization = each.value.authorization
  })

  script_language      = ""
  runtime_type         = ""
  runtime_type_version = ""

  tag {
    key    = "brand"
    values = ["LEGALCERT"]
  }
  tag {
    key    = "team"
    values = ["LegalCert"]
  }
  tag {
    key    = "environment"
    values = ["${var.env}"]
  }
  tag {
    key    = "technical_service"
    values = ["ST Registration Authority"]
  }
}

# Alert condition: result
resource "newrelic_nrql_alert_condition" "lcert_wcrs_scripted_API_result_NRQL" {
  for_each = var.enable_API_checks ? var.wcrs_scripted_API_checks : {}

  policy_id = newrelic_alert_policy.lcert_wcrs_policy.id

  name    = "result WCRS ${each.value.label}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 900 : 600 // window is 15 min (3 cons checks) for priv loc tests, 10 mins (3 cons checks) for public loc tests
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  fill_option        = "none"
  slide_by           = 60

  violation_time_limit_seconds   = 172800 // long lasting incidents will close after 2 days
  expiration_duration            = 1800   // signal considered as expired if no data is returned for 30 minutes (6 consequent checks)
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` = '${newrelic_synthetics_script_monitor.lcert_wcrs_scripted_API_checks[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 2 checks every 5m
  // error when 4/6 failures in 15m window
  // for probes executed from PRIVATE locations:
  // 1 check every 5m
  // error when 3/3 in 20m window
  critical {
    operator              = "above"
    threshold             = each.value.priv_loc ? 2 : 3
    threshold_duration    = each.value.priv_loc ? 1200 : 900 
    threshold_occurrences = "at_least_once"
  }
}

# Alert condition: duration
resource "newrelic_nrql_alert_condition" "lcert_wcrs_scripted_API_duration_NRQL" {
  for_each = var.enable_API_checks ? var.wcrs_scripted_API_checks : {}

  policy_id = newrelic_alert_policy.lcert_wcrs_policy.id

  name    = "duration WCRS ${each.value.label}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 900 : 600 // window is 15 min (3 cons checks) for priv loc tests, 10 mins (3 cons checks) for public loc tests
  aggregation_method = "event_flow" 
  aggregation_delay  = 60
  fill_option        = "last_value"
  slide_by           = 60

  violation_time_limit_seconds   = 172800 // long lasting incidents will close after 2 days
  expiration_duration            = 1800 // Signal is considered to be expired if no data is returned for 30 minutes (6 consequent checks)
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT average(duration)
FROM SyntheticCheck
WHERE `monitorName` = '${newrelic_synthetics_script_monitor.lcert_wcrs_scripted_API_checks[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 2 checks every 5m
  // error when duration above thresh for 20m window
  // for probes executed from PRIVATE locations:
  // 1 check every 5m
  // error when duration above thresh for 30m window
  critical {
    operator              = "above"
    threshold             = each.value.duration_thr
    threshold_duration    = each.value.priv_loc ? 1800 : 1200
    threshold_occurrences = "all"
  }
}

# Alert condition: No data
resource "newrelic_nrql_alert_condition" "lcert_synthetics_NRQL_check_once_day_nodata" {
  for_each = var.enable_API_checks ? var.wcrs_scripted_API_checks : {}

  policy_id = newrelic_alert_policy.lcert_wcrs_policy.id

  name    = "no data WCRS ${each.value.label}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = 600 // window is 10 min (2 cons checks) for priv loc tests, 10 mins (4 cons checks) for public loc tests
  aggregation_method = "event_flow" 
  aggregation_delay  = 60
  fill_option        = "last_value"
  slide_by           = 60

  violation_time_limit_seconds   = 2592000 // long lasting incidents will close after 30 days
  expiration_duration            = 90000 // Signal is considered to be expired if no data is returned for 25 hours
  open_violation_on_expiration   = true
  
  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `monitorName` = '${newrelic_synthetics_script_monitor.lcert_wcrs_scripted_API_checks[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 3600
    threshold_occurrences = "at_least_once"
  }
}