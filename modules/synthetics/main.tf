# variables
locals {
  tags = {
    brand       = "LEGALCERT"
    team        = "LegalCert"
    environment = var.env
  }
}

# policy
resource "newrelic_alert_policy" "lcert_synthetics_policy" {
  name                = "lcert ${var.env} synthetics policy"
  incident_preference = "PER_CONDITION"
}

# notification channel
data "newrelic_alert_channel" "lcert_synthetics_channel" {
  name = var.notification
}

resource "newrelic_alert_policy_channel" "lcert_synthetics_policy_channel" {
  policy_id   = newrelic_alert_policy.lcert_synthetics_policy.id
  channel_ids = [data.newrelic_alert_channel.lcert_synthetics_channel.id]
}

# synthetics
data "newrelic_synthetics_monitor_location" "legalcert_mgmt" {
  label = "LegalCert MGMT"
}

# synthetics jobmanager w/Chrome 100+
data "newrelic_synthetics_monitor_location" "legalcert_mgmt_jobmanager" {
  label = "LegalCert MGMT JobManager"
}

# script browser
resource "newrelic_synthetics_monitor" "lcert_synthetics_wsdl_check" {
  for_each = var.enable_checks ? var.checks_info : {}

  name      = "PUB | ${each.value.product} | ${upper(var.env)} | ${each.value.label} - URL ${each.value.url_num}"
  type      = "SCRIPT_BROWSER"
  frequency = each.value.freq //10
  status    = each.value.enabled ? "ENABLED" : "DISABLED"
  locations = each.value.priv_loc ? [data.newrelic_synthetics_monitor_location.legalcert_mgmt_jobmanager.name] : each.value.multi_loc ? ["AWS_EU_SOUTH_1", "AWS_EU_WEST_1"] : ["AWS_EU_WEST_1"]
}

module "tag_lcert_synthetics_wsdl_check" {
  source   = "../tag"
  for_each = var.enable_checks ? var.checks_info : {}

  name = "PUB | ${each.value.product} | ${upper(var.env)} | ${each.value.label} - URL ${each.value.url_num}"
  tag = {
    brand             = local.tags.brand
    team              = local.tags.team
    environment       = local.tags.environment
    technical_service = each.value.tech_serv
  }

  depends_on = [
    newrelic_synthetics_monitor.lcert_synthetics_wsdl_check
  ]
}

resource "newrelic_synthetics_monitor_script" "lcert_synthetics_wsdl_check" {
  for_each = var.enable_checks ? var.checks_info : {}

  monitor_id = newrelic_synthetics_monitor.lcert_synthetics_wsdl_check[each.key].id
  text = templatefile("${path.module}/scripts/${each.value.script}",
    {
      url          = each.value.url
      service_name = each.value.service_name
      user         = each.value.user
      pass         = each.value.pass
  })
}

resource "newrelic_nrql_alert_condition" "lcert_synthetics_NRQL_check" {
  for_each = var.enable_checks ? var.checks_info : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "result ${each.value.product} ${each.value.label} - URL ${each.value.url_num}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 1800 : 1200
  aggregation_method = "event_flow" 
  aggregation_delay  = 60
  fill_option        = "none"
  slide_by           = 60

  violation_time_limit_seconds   = 172800 // long lasting incidents will close after 2 days
  expiration_duration            = 3600 //each.value.priv_loc ? 2400 : 1800
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_wsdl_check[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 2 checks every 10m
  // error when 4/4 in 25m window
  // for probes executed from PRIVATE locations:
  // 1 check every 10m
  // error when 3/3 in 35m window
  critical {
    operator              = "above"
    threshold             = each.value.priv_loc ? 2 : 3
    threshold_duration    = each.value.priv_loc ? 2100 : 1500 
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "lcert_synt_duration_NRQL_check" {
  for_each = var.enable_checks ? var.checks_info : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "duration ${each.value.product} ${each.value.label} - URL ${each.value.url_num}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 1800 : 1200
  aggregation_method = "event_flow" 
  aggregation_delay  = 60
  fill_option        = "last_value"
  slide_by           = 60

  expiration_duration            = 3600 // Signal is considered to be expired if no data is returned for 60 minutes (6 consequent checks)
  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT average(duration)
FROM SyntheticCheck
WHERE `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_wsdl_check[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 2 checks every 10m
  // error when duration above thresh for 40m window
  // for probes executed from PRIVATE locations:
  // 1 check every 10m
  // error when duration above thresh for 30m window
  critical {
    operator              = "above"
    threshold             = each.value.duration_thr
    threshold_duration    = each.value.priv_loc ? 1800 : 2400
    threshold_occurrences = "all"
  }
}

# api monitors
resource "newrelic_synthetics_monitor" "lcert_synthetics_API_check" {
  for_each = var.enable_checks ? var.API_checks_info : {}

  name      = "PUB | ${each.value.product} | ${upper(var.env)} | ${each.value.label} - URL ${each.value.url_num}"
  type      = "SCRIPT_API"
  frequency = 10
  status    = each.value.enabled ? "ENABLED" : "DISABLED"
  locations = each.value.priv_loc ? [data.newrelic_synthetics_monitor_location.legalcert_mgmt.name] : each.value.multi_loc ? ["AWS_EU_SOUTH_1", "AWS_EU_CENTRAL_1", "AWS_EU_WEST_1"] : ["AWS_EU_SOUTH_1", "AWS_EU_WEST_1"]
}

module "tag_lcert_synthetics_API_check" {
  source   = "../tag"
  for_each = var.enable_checks ? var.API_checks_info : {}

  name = "PUB | ${each.value.product} | ${upper(var.env)} | ${each.value.label} - URL ${each.value.url_num}"
  tag = {
    brand             = local.tags.brand
    team              = local.tags.team
    environment       = local.tags.environment
    technical_service = each.value.tech_serv
  }

  depends_on = [
    newrelic_synthetics_monitor.lcert_synthetics_API_check
  ]
}

resource "newrelic_synthetics_monitor_script" "lcert_synthetics_API_check" {
  for_each = var.enable_checks ? var.API_checks_info : {}

  monitor_id = newrelic_synthetics_monitor.lcert_synthetics_API_check[each.key].id
  text = templatefile("${path.module}/scripts/${each.value.script}",
    {
      url          = each.value.url
      service_name = each.value.service_name
      user         = each.value.user
      pass         = each.value.pass
  })
}

resource "newrelic_nrql_alert_condition" "lcert_synthetics_API_NRQL_check" {
  for_each = var.enable_checks ? var.API_checks_info : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "result ${each.value.product} ${each.value.label} - URL ${each.value.url_num}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 1800 : 1200
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  fill_option        = "none"
  slide_by           = 60

  violation_time_limit_seconds   = 172800 // long lasting incidents will close after 2 days
  expiration_duration            = 3600 //each.value.priv_loc ? 2400 : 1800
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_API_check[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 2 checks every 10m
  // error when 4/4 in 25m window
  // for probes executed from PRIVATE locations:
  // 1 check every 10m
  // error when 3/3 in 35m window
  critical {
    operator              = "above"
    threshold             = each.value.priv_loc ? 2 : 3
    threshold_duration    = each.value.priv_loc ? 2100 : 1500 
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "lcert_synt_duration_API_NRQL_check" {
  for_each = var.enable_checks ? var.API_checks_info : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "duration ${each.value.product} ${each.value.label} - URL ${each.value.url_num}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 1800 : 1200
  aggregation_method = "event_flow" 
  aggregation_delay  = 60
  fill_option        = "last_value"
  slide_by           = 60

  expiration_duration            = 3600 // Signal is considered to be expired if no data is returned for 60 minutes (6 consequent checks)
  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT average(duration)
FROM SyntheticCheck
WHERE `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_API_check[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 2 checks every 10m
  // error when duration above thresh for 40m window
  // for probes executed from PRIVATE locations:
  // 1 check every 10m
  // error when duration above thresh for 30m window
  critical {
    operator              = "above"
    threshold             = each.value.duration_thr
    threshold_duration    = each.value.priv_loc ? 1800 : 2400
    threshold_occurrences = "all"
  }
}

# simple browser
resource "newrelic_synthetics_monitor" "lcert_synthetics_simple_browser_check" {
  for_each = var.enable_simple_browser_checks ? var.SIMPLE_BROWSER_checks_info : {}

  name              = "SIGN | ${each.value.product} | ${upper(var.env)} | ${each.value.label}"
  type              = "BROWSER"
  frequency         = 10
  status            = each.value.enabled ? "ENABLED" : "DISABLED"
  locations         = each.value.priv_loc ? [data.newrelic_synthetics_monitor_location.legalcert_mgmt.name] : ["AWS_EU_SOUTH_1", "AWS_EU_WEST_1"]
  uri               = each.value.url
  validation_string = each.value.pattern
  verify_ssl        = false
}

module "tag_lcert_synthetics_simple_browser_check" {
  source   = "../tag"
  for_each = var.enable_simple_browser_checks ? var.SIMPLE_BROWSER_checks_info : {}

  name = "SIGN | ${each.value.product} | ${upper(var.env)} | ${each.value.label}"
  tag = {
    brand             = local.tags.brand
    team              = "Sign"
    environment       = local.tags.environment
    technical_service = each.value.tech_serv
  }

  depends_on = [
    newrelic_synthetics_monitor.lcert_synthetics_simple_browser_check
  ]
}

resource "newrelic_nrql_alert_condition" "lcert_synt_simple_NRQL_check_result" {
  for_each = var.enable_simple_browser_checks ? var.SIMPLE_BROWSER_checks_info : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "result ${each.value.product} ${each.value.label}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 1800 : 1200
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  fill_option        = "none"
  slide_by           = 60

  violation_time_limit_seconds   = 172800 // long lasting incidents will close after 2 days
  expiration_duration            = 3600
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_simple_browser_check[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 2 checks every 10m
  // error when 4/4 in 25m window
  // for probes executed from PRIVATE locations:
  // 1 check every 10m
  // error when 3/3 in 35m window
  critical {
    operator              = "above"
    threshold             = each.value.priv_loc ? 2 : 3
    threshold_duration    = each.value.priv_loc ? 2100 : 1500 
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "lcert_synt_simple_NRQL_check_duration" {
  for_each = var.enable_simple_browser_checks ? var.SIMPLE_BROWSER_checks_info : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "duration ${each.value.product} ${each.value.label}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 1800 : 1200
  aggregation_method = "event_flow" 
  aggregation_delay  = 60
  fill_option        = "last_value"
  slide_by           = 60

  expiration_duration            = 3600 // Signal is considered to be expired if no data is returned for 60 minutes (6 consequent checks)
  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT average(duration)
FROM SyntheticCheck
WHERE `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_simple_browser_check[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 2 checks every 10m
  // error when duration above thresh for 40m window
  // for probes executed from PRIVATE locations:
  // 1 check every 10m
  // error when duration above thresh for 30m window
  critical {
    operator              = "above"
    threshold             = each.value.duration_thr
    threshold_duration    = each.value.priv_loc ? 1800 : 2400
    threshold_occurrences = "all"
  }
}

# CA private location
data "newrelic_synthetics_monitor_location" "legalcert_mgmt_ca" {
  label = "LegalCert MGMT CA"
}

# simple browser CA
resource "newrelic_synthetics_monitor" "lcert_synthetics_simple_browser_CA_check" {
  for_each = var.enable_simple_browser_checks ? var.SIMPLE_BROWSER_CA_checks_info : {}

  name              = "SIGN | ${each.value.product} | ${upper(var.env)} | ${each.value.label}"
  type              = "BROWSER"
  frequency         = 10
  status            = each.value.enabled ? "ENABLED" : "DISABLED"
  locations         = each.value.priv_loc ? [data.newrelic_synthetics_monitor_location.legalcert_mgmt_ca.name] : ["AWS_EU_SOUTH_1", "AWS_EU_WEST_1"]
  uri               = each.value.url
  validation_string = each.value.pattern
  verify_ssl        = false
}

module "tag_lcert_synthetics_simple_browser_CA_check" {
  source   = "../tag"
  for_each = var.enable_simple_browser_checks ? var.SIMPLE_BROWSER_CA_checks_info : {}

  name = "SIGN | ${each.value.product} | ${upper(var.env)} | ${each.value.label}"
  tag = {
    brand             = local.tags.brand
    team              = "Sign"
    environment       = local.tags.environment
    technical_service = each.value.tech_serv
  }

  depends_on = [
    newrelic_synthetics_monitor.lcert_synthetics_simple_browser_CA_check
  ]
}

resource "newrelic_nrql_alert_condition" "lcert_synt_simple_CA_NRQL_check_result" {
  for_each = var.enable_simple_browser_checks ? var.SIMPLE_BROWSER_CA_checks_info : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "result ${each.value.product} ${each.value.label}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 1800 : 1200
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  fill_option        = "none"
  slide_by           = 60

  violation_time_limit_seconds   = 172800 // long lasting incidents will close after 2 days
  expiration_duration            = 3600
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_simple_browser_CA_check[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 2 checks every 10m
  // error when 4/4 in 25m window
  // for probes executed from PRIVATE locations:
  // 1 check every 10m
  // error when 3/3 in 35m window
  critical {
    operator              = "above"
    threshold             = each.value.priv_loc ? 2 : 3
    threshold_duration    = each.value.priv_loc ? 2100 : 1500
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "lcert_synt_simple_CA_NRQL_check_duration" {
  for_each = var.enable_simple_browser_checks ? var.SIMPLE_BROWSER_CA_checks_info : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "duration ${each.value.product} ${each.value.label}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 1800 : 1200
  aggregation_method = "event_flow" 
  aggregation_delay  = 60
  fill_option        = "last_value"
  slide_by           = 60

  expiration_duration            = 3600 // Signal is considered to be expired if no data is returned for 60 minutes (6 consequent checks)
  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT average(duration)
FROM SyntheticCheck
WHERE `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_simple_browser_CA_check[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 2 checks every 10m
  // error when duration above thresh for 40m window
  // for probes executed from PRIVATE locations:
  // 1 check every 10m
  // error when duration above thresh for 30m window
  critical {
    operator              = "above"
    threshold             = each.value.duration_thr
    threshold_duration    = each.value.priv_loc ? 1800 : 2400
    threshold_occurrences = "all"
  }
}

## Scripted API with frequency of once per day
# Result
resource "newrelic_synthetics_monitor" "lcert_synthetics_wsdl_check_once_day" {
  for_each = var.enable_checks ? var.checks_info_once_day : {}

  name      = "PUB | ${each.value.product} | ${upper(var.env)} | ${each.value.label} - URL ${each.value.url_num}"
  type      = "SCRIPT_API"
  frequency = each.value.freq
  status    = each.value.enabled ? "ENABLED" : "DISABLED"
  locations = each.value.priv_loc ? [data.newrelic_synthetics_monitor_location.legalcert_mgmt.name] : each.value.multi_loc ? ["AWS_EU_SOUTH_1", "AWS_EU_WEST_1"] : ["AWS_EU_SOUTH_1"]
  
}

module "tag_lcert_synthetics_wsdl_check_once_day" {
  source   = "../tag"
  for_each = var.enable_checks ? var.checks_info_once_day : {}

  name = "PUB | ${each.value.product} | ${upper(var.env)} | ${each.value.label} - URL ${each.value.url_num}"
  tag = {
    brand             = local.tags.brand
    team              = local.tags.team
    environment       = local.tags.environment
    technical_service = each.value.tech_serv
  }

  depends_on = [
    newrelic_synthetics_monitor.lcert_synthetics_wsdl_check_once_day
  ]
}

resource "newrelic_synthetics_monitor_script" "lcert_synthetics_wsdl_check_once_day" {
  for_each = var.enable_checks ? var.checks_info_once_day : {}

  monitor_id = newrelic_synthetics_monitor.lcert_synthetics_wsdl_check_once_day[each.key].id
  text = templatefile("${path.module}/scripts/${each.value.script}",
    {
      url          = each.value.url
      service_name = each.value.service_name
      user         = each.value.user
      pass         = each.value.pass
  })
}

resource "newrelic_nrql_alert_condition" "lcert_synthetics_NRQL_check_once_day" {
  for_each = var.enable_checks ? var.checks_info_once_day : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "result ${each.value.product} ${each.value.label} - URL ${each.value.url_num}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = 120
  aggregation_method = "event_flow" 
  aggregation_delay  = 60
  fill_option        = "last_value"
  slide_by           = 60

  violation_time_limit_seconds   = 2592000 // long lasting incidents will close after 30 days
  expiration_duration            = 86400   // 24 hours
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_wsdl_check_once_day[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PRIVATE locations once a day:
  // 1 check every 86400m
  // error when 1/1 in 2m window
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 120 
    threshold_occurrences = "at_least_once"
  }
}

# No data
resource "newrelic_nrql_alert_condition" "lcert_synthetics_NRQL_check_once_day_nodata" {
  for_each = var.enable_checks ? var.checks_info_once_day : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "no data ${each.value.product} ${each.value.label} - URL ${each.value.url_num}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = 3600          // 86400: 24 hours
  aggregation_method = "cadence"
  aggregation_delay  = 900          // 3600: 1 hour
  //slide_by           = 1800          // 1800: 30 mins
  fill_option        = "last_value"

  violation_time_limit_seconds = 2592000  // 30 days
  expiration_duration          = 90000    // 86400: 24 hours - 90000: 25 hours
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_wsdl_check_once_day[each.key].name}'
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


# PING Monitors
resource "newrelic_synthetics_monitor" "lcert_synthetics_ping_check" {
  for_each = var.enable_checks ? var.ping_monitors : {}

  name              = "PUB | ${each.value.product} | ${upper(var.env)} | ${each.value.label} - URL ${each.value.url_num}"
  type              = "SIMPLE"
  frequency         = each.value.freq //10
  status            = each.value.enabled ? "ENABLED" : "DISABLED"
  locations         = each.value.priv_loc ? each.value.priv_loc_ca ? [data.newrelic_synthetics_monitor_location.legalcert_mgmt_ca.name] : [data.newrelic_synthetics_monitor_location.legalcert_mgmt.name] : each.value.multi_loc ? ["AWS_EU_SOUTH_1", "AWS_EU_CENTRAL_1", "AWS_EU_WEST_1"] : ["AWS_EU_WEST_1"]
  uri               = "${each.value.url}"
  validation_string = "${each.value.service_name}"

}

module "tag_lcert_synthetics_ping_check" {
  source   = "../tag"
  for_each = var.enable_checks ? var.ping_monitors : {}

  name = "PUB | ${each.value.product} | ${upper(var.env)} | ${each.value.label} - URL ${each.value.url_num}"
  tag = {
    brand             = local.tags.brand
    team              = local.tags.team
    environment       = local.tags.environment
    technical_service = each.value.tech_serv
  }

  depends_on = [
    newrelic_synthetics_monitor.lcert_synthetics_ping_check
  ]
}

resource "newrelic_nrql_alert_condition" "lcert_ping_result_check" {
  for_each = var.enable_checks ? var.ping_monitors : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "result ${each.value.product} ${each.value.label} - URL ${each.value.url_num}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 1800 : 1200
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  fill_option        = "none"
  slide_by           = 60

  violation_time_limit_seconds   = 172800 // long lasting incidents will close after 2 days
  expiration_duration            = 3600
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_ping_check[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 3 checks every 10m
  // error when 4/6 in 25m window
  // for probes executed from PRIVATE locations:
  // 1 check every 10m
  // error when 3/3 in 35m window
  critical {
    operator              = "above"
    threshold             = each.value.priv_loc ? 2 : 3
    threshold_duration    = each.value.priv_loc ? 1800 : 1200 
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "lcert_ping_duration_check" {
  for_each = var.enable_checks ? var.ping_monitors : {}

  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "duration ${each.value.product} ${each.value.label} - URL ${each.value.url_num}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = each.value.priv_loc ? 1800 : 1200
  aggregation_method = "event_flow" 
  aggregation_delay  = 60
  fill_option        = "last_value"
  slide_by           = 60

  expiration_duration            = 3600 // Signal is considered to be expired if no data is returned for 60 minutes (6 consequent checks)
  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT average(duration)
FROM SyntheticCheck
WHERE `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_ping_check[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }
  // for probes executed from PUBLIC locations:
  // 3 checks every 10m
  // error when duration above thresh for 40m window
  // for probes executed from PRIVATE locations:
  // 1 check every 10m
  // error when duration above thresh for 30m window
  critical {
    operator              = "above"
    threshold             = each.value.duration_thr
    threshold_duration    = each.value.priv_loc ? 1800 : 2400
    threshold_occurrences = "all"
  }
}

# No data ping monitors
resource "newrelic_nrql_alert_condition" "lcert_ping_nodata_check" {
  for_each = var.enable_checks ? var.ping_monitors : {}
  //count     = var.enable_checks ? length(var.ping_monitors[*]) > 0 ? 1 : 0 : 0
  policy_id = newrelic_alert_policy.lcert_synthetics_policy.id

  name    = "no data ${each.value.product} ${each.value.label} - URL ${each.value.url_num}"
  type    = "static"
  enabled = each.value.enabled

  aggregation_window = 3600  // da mettere a 60 min per public loc (3 check ogni 10 min) e 60 min per private loc (1 check ogni 10 min)
  aggregation_method = "event_timer"
  aggregation_timer  = 900
  fill_option        = "last_value"

  violation_time_limit_seconds = 2592000  // 30 days
  expiration_duration          = 90000    // 86400: 24 hours - 90000: 25 hours
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `monitorName` = '${newrelic_synthetics_monitor.lcert_synthetics_ping_check[each.key].name}'
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