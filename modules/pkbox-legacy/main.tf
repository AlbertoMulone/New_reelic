# variables
locals {
  tags = {
    brand             = "LEGALCERT"
    team              = "LegalCert"
    environment       = var.env
    technical_service = "ST Firma Remota Intesi"
  }
}

# policy
resource "newrelic_alert_policy" "lcert_pkbox_policy" {
  name = "lcert ${var.env} pkbox ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} pkbox ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_pkbox_policy.id
  notification = var.notification
}

# nagios
resource "newrelic_nrql_alert_condition" "nagios" {
  for_each = toset(var.nagios_checks)

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = each.value
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
FROM NagiosRemoteCheckSample
WHERE `nagios.check` = '${each.value}'
AND `nagios.rc` >= 2
AND `nagios.service_name` = '${var.service_name}'
AND `nagios.environment` IN ('${join("', '", var.network_envs)}')
FACET `nagios.vm` as fullHostname,
      `nagios.brand` as brand,
      `nagios.team` as team,
      `nagios.environment` as environment,
      `nagios.technical_service` as technical_service
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
resource "newrelic_nrql_alert_condition" "pkbox_no_data" {
  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "pkbox no data"
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
FROM NagiosRemoteCheckSample
WHERE `nagios.check` IN ('${join("', '", var.nagios_checks)}')
AND `nagios.service_name` = '${var.service_name}'
AND `nagios.environment` IN ('${join("', '", var.network_envs)}')
FACET `nagios.vm` as fullHostname,
      `nagios.check` as displayName,
      `nagios.brand` as brand,
      `nagios.team` as team,
      `nagios.environment` as environment,
      `nagios.technical_service` as technical_service
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
data "newrelic_synthetics_private_location" "legalcert_mgmt" {
  name = "LegalCert MGMT"
}

data "aws_secretsmanager_secret_version" "newrelic" {
  secret_id = "newrelic"
}

locals {
  newrelic_secret = jsondecode(data.aws_secretsmanager_secret_version.newrelic.secret_string)
}

# pkbox url balancer
resource "newrelic_synthetics_monitor" "pkbox_url_balancer" {
  count = var.enable_balancer ? 1 : 0

  status = "ENABLED"
  name   = "lcert ${var.env} pkbox ${var.label} url ${var.balancer.host} balancer"
  period = "EVERY_5_MINUTES"
  type   = "SIMPLE"
  uri    = "${var.enable_ssl ? "https" : "http"}://${var.basic_auth ? "${local.newrelic_secret.pkbox_sign_username}:${local.newrelic_secret.pkbox_sign_password}" : ""}@${var.balancer.host}:${var.balancer.port}/pkserver/"

  locations_private = [data.newrelic_synthetics_private_location.legalcert_mgmt.id]

  verify_ssl        = var.verify_ssl

  dynamic "tag" {
    for_each = local.tags

    content {
      key   = tag.key
      values = [tag.value]
    }
  }
}

resource "newrelic_nrql_alert_condition" "pkbox_url_balancer" {
  count = var.enable_balancer ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "url ${var.balancer.host} balancer"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1200
  aggregation_method = "event_flow"
  aggregation_delay  = 60
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
AND `monitorName` = '${newrelic_synthetics_monitor.pkbox_url_balancer[count.index].name}'
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

resource "newrelic_nrql_alert_condition" "pkbox_url_balancer_duration" {
  count = var.enable_balancer ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "url ${var.balancer.host} balancer duration"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1200
  aggregation_method = "event_flow"
  aggregation_delay  = 60
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
AND `monitorName` = '${newrelic_synthetics_monitor.pkbox_url_balancer[count.index].name}'
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

# pkbox url handlers
locals {
  url_handlers = flatten([
    for host_key, host in var.hosts : [
      for handler in var.handlers : {
        key     = host_key
        url     = "${var.enable_ssl ? "https" : "http"}://${host.host}:${host.port}/pkserver/servlet/${handler}handler"
        host    = host.host
        handler = handler
      }
    ]
  ])

  url_handlers_map = {
    for url in local.url_handlers : "${url.host} ${url.handler}handler" => url
  }
}

resource "newrelic_synthetics_monitor" "pkbox_url_handlers" {
  for_each = local.url_handlers_map

  status = "ENABLED"
  name   = "lcert ${var.env} pkbox ${var.label} url ${each.key}"
  period = "EVERY_5_MINUTES"
  type   = "SIMPLE"
  uri    = each.value.url

  locations_private = [data.newrelic_synthetics_private_location.legalcert_mgmt.id]

  validation_string = each.value.handler
  verify_ssl        = var.verify_ssl

  dynamic "tag" {
    for_each = local.tags

    content {
      key   = tag.key
      values = [tag.value]
    }
  }
}

resource "newrelic_nrql_alert_condition" "pkbox_url_handlers" {
  for_each = local.url_handlers_map

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "url ${each.key}"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1200
  aggregation_method = "event_flow"
  aggregation_delay  = 60
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
AND `monitorName` = '${newrelic_synthetics_monitor.pkbox_url_handlers[each.key].name}'
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

resource "newrelic_nrql_alert_condition" "pkbox_url_handlers_duration" {
  for_each = local.url_handlers_map

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "url ${each.key} duration"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1200
  aggregation_method = "event_flow"
  aggregation_delay  = 60
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
AND `monitorName` = '${newrelic_synthetics_monitor.pkbox_url_handlers[each.key].name}'
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

# pkbox url max credential
resource "newrelic_synthetics_script_monitor" "pkbox_url_max_credential" {
  count = var.enable_max_credentials ? 1 : 0

  status = "ENABLED"
  name   = "lcert ${var.env} pkbox ${var.label} url ${var.hosts["1"].host} max credential"
  period = "EVERY_5_MINUTES"
  type   = "SCRIPT_BROWSER"

  location_private {
    guid         = data.newrelic_synthetics_private_location.legalcert_mgmt.id
    vse_password = local.newrelic_secret.synthetic_private_password
  }

  script          = templatefile("${path.module}/../pkbox/max_credential_script.tpl", 
    {
      url                   = "${var.enable_ssl ? "https" : "http"}://${var.basic_auth ? "\" + $secure.PKBOX_USER + \":\" + $secure.PKBOX_PASSWORD + \"" : ""}@${var.hosts["1"].host}:${var.hosts["1"].port}/pkserver/system/systemhandler"
      max_credentials_limit = var.max_credentials_limit
    })

  dynamic "tag" {
    for_each = local.tags

    content {
      key   = tag.key
      values = [tag.value]
    }
  }
}

resource "newrelic_nrql_alert_condition" "pkbox_url_max_credential" {
  count = var.enable_max_credentials ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "url ${var.hosts["1"].host} max credential"
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
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` = '${newrelic_synthetics_script_monitor.pkbox_url_max_credential[count.index].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF

  }

  // 1 check every 5m
  // error when 3/3 in 20m window
  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }

}
