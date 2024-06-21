# variables
locals {
  tags = {
    brand             = "LEGALCERT"
    team              = "LegalCert"
    environment       = var.env
    technical_service = "ST PKI INTESA IDENTRUST"
  }
}

# policy
resource "newrelic_alert_policy" "lcert_unicert_policy" {
  name = "lcert ${var.env} unicert ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} unicert ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_unicert_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_unicert_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  violation_close_timer = 72
}

# process
resource "newrelic_infra_alert_condition" "caservice_not_running" {
  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name          = "CAService not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'CAService'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "cssservice_not_running" {
  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name          = "CSSService not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'CSSService'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "raservice_not_running" {
  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name          = "RAService not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'RAService'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "raxservice_not_running" {
  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name          = "RAXService not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'RAXService'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "publisherservic_not_running" {
  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name          = "PublisherServic not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'PublisherServic'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "filemonitor_not_running" {
  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name          = "FileMonitor not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'FileMonitor'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "tomcat_not_running" {
  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name          = "tomcat not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '/opt/unicert/Verizon/UniCERT/jdk/bin/java'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

# ntpd
resource "newrelic_infra_alert_condition" "ntpd_not_running" {
  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name          = "ntpd not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'ntpd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

# nagios
resource "newrelic_nrql_alert_condition" "compliance_cert_error" {
  count = var.enable_nagios && var.enable_compliance ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name    = "compliance cert error"
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
WHERE `displayName` = 'compliance_cert'
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

resource "newrelic_nrql_alert_condition" "compliance_crl_error" {
  count = var.enable_nagios && var.enable_compliance ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name    = "compliance crl error"
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
WHERE `displayName` = 'compliance_crl'
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
resource "newrelic_nrql_alert_condition" "unicert_no_data" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name    = "unicert no data"
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
WHERE `displayName` IN ('compliance_cert', 'compliance_crl')
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

# synthetics

# private location
data "newrelic_synthetics_private_location" "legalcert_mgmt" {
  name = "LegalCert MGMT"
}

data "newrelic_synthetics_private_location" "legalcert_mgmt_ca" {
  name = "LegalCert MGMT CA"
}

locals {
  url_handlers = flatten([
    for host_key, host in var.hosts : [
      for handler in var.handlers : {
        key     = host_key
        url     = "${var.enable_ssl ? "https" : "http"}://${host.host}:${host.port}/${handler}/"
        host    = host.host
        handler = handler
      }
    ]
  ])

  url_handlers_map = {
    for url in local.url_handlers : "${url.host} ${url.handler}" => url
  }
}

resource "newrelic_synthetics_monitor" "unicert_url_handlers" {
  for_each = local.url_handlers_map

  status = "ENABLED"
  name   = "lcert ${var.env} unicert ${var.label} url ${each.key}"
  period = "EVERY_5_MINUTES"
  type   = "SIMPLE"
  uri    = each.value.url

  locations_private = var.location_ca ? [data.newrelic_synthetics_private_location.legalcert_mgmt_ca.id] : [data.newrelic_synthetics_private_location.legalcert_mgmt.id]

  validation_string = "UniCERT Web Handler"
  verify_ssl        = var.verify_ssl

  dynamic "tag" {
    for_each = local.tags

    content {
      key   = tag.key
      values = [tag.value]
    }
  }
}

resource "newrelic_nrql_alert_condition" "unicert_url_handlers" {
  for_each = local.url_handlers_map

  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name    = "url ${each.key}"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1200
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1200
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` = '${newrelic_synthetics_monitor.unicert_url_handlers[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF
  }

  // 1 check every 5m
  // error when 3/3 in 20m window
  critical {
    operator              = "above"
    threshold             = "2"
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }

}

resource "newrelic_nrql_alert_condition" "unicert_url_handlers_duration" {
  for_each = local.url_handlers_map

  policy_id = newrelic_alert_policy.lcert_unicert_policy.id

  name    = "url ${each.key} duration"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1200
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1200
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `duration` > 2000
AND `monitorName` = '${newrelic_synthetics_monitor.unicert_url_handlers[each.key].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF
  }

  // 1 check every 5m
  // error when 3/3 in 20m window
  critical {
    operator              = "above"
    threshold             = "2"
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }

}
