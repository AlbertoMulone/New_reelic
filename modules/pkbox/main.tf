# variables
locals {
  tags = {
    brand             = "LEGALCERT"
    team              = "LegalCert"
    environment       = var.env
    technical_service = "ST Firma Remota Intesi"
  }
}

# policy pkbox
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

# policy pkbox synthetics
resource "newrelic_alert_policy" "lcert_pkbox_synth_policy" {
  name                = "lcert ${var.env} pkbox ${var.label} synthetics policy"
  incident_preference = "PER_CONDITION"
}

# notification synth
module "notification_synth" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} pkbox ${var.label} synthetics"
  policy_id    = newrelic_alert_policy.lcert_pkbox_synth_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  enable_fs_read_only    = true
  high_cpu_usage_percent = var.high_cpu_usage_percent
}

# process
resource "newrelic_infra_alert_condition" "pkbox_not_running" {
  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name          = "pkbox_not_running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandLine` = '${var.pkbox_command_line}'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

# nagios
resource "newrelic_nrql_alert_condition" "pkbox_check_users_logged_in" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "pkbox_check_users_logged_in"
  type    = "static"
  enabled = false

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
WHERE `displayName` = 'pkbox_check_users_logged_in'
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

resource "newrelic_nrql_alert_condition" "pkbox_check_cdrom" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "pkbox_check_cdrom"
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
WHERE `displayName` = 'pkbox_check_cdrom'
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

resource "newrelic_nrql_alert_condition" "pkbox_check_usb" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "pkbox_check_usb"
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
WHERE `displayName` = 'pkbox_check_usb'
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

resource "newrelic_nrql_alert_condition" "pkbox_check_interface_eth0" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "pkbox_check_interface_eth0"
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
WHERE `displayName` = 'pkbox_check_interface_eth0'
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

resource "newrelic_nrql_alert_condition" "pkbox_check_nfast" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "pkbox_check_nfast"
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
WHERE `displayName` = 'pkbox_check_nfast'
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

resource "newrelic_nrql_alert_condition" "pkbox_check_hsm_objectcount" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "pkbox_check_hsm_objectcount"
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
WHERE `displayName` = 'pkbox_check_hsm_objectcount'
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

resource "newrelic_nrql_alert_condition" "pkbox_check_dir_work" {
  count = var.enable_nagios ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "pkbox_check_dir_work"
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
WHERE `displayName` = 'pkbox_check_dir_work'
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
resource "newrelic_nrql_alert_condition" "pkbox_no_data" {
  count = var.enable_nagios ? 1 : 0

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
FROM NagiosServiceCheckSample
WHERE `displayName` IN ('pkbox_check_users_logged_in',
                        'pkbox_check_cdrom',
                        'pkbox_check_usb',
                        'pkbox_check_interface_eth0',
                        'pkbox_check_nfast',
                        'pkbox_check_hsm_objectcount',
                        'pkbox_check_dir_work')
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

# ntpd service status
resource "newrelic_nrql_alert_condition" "pkbox_ntpd_status" {
  count = var.enable_ntpd_check ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "libpkbox001/002: ntpd service not running"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 960
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1800
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM PKBOX_ntp_Sample
WHERE `NTP_SERVICE` != 'OK'
AND `environment` = 'prod'
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 960
    threshold_occurrences = "all"
  }

}

# ntpd service jitter
resource "newrelic_nrql_alert_condition" "pkbox_ntpd_jitter" {
  count = var.enable_ntpd_check ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "libpkbox001/002: ntpd service not in sync"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 960
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1800
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM PKBOX_ntp_Sample
WHERE `JITTER` > 1000
AND `environment` = 'prod'
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = 960
    threshold_occurrences = "all"
  }

}

# ntpd service no data
resource "newrelic_nrql_alert_condition" "pkbox_ntpd_no_data" {
  count = var.enable_ntpd_check ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_pkbox_policy.id

  name    = "libpkbox001/002: ntpd service no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1860
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 2700
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM PKBOX_ntp_Sample
WHERE `environment` = 'prod'
FACET `fullHostname`, `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 1860
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

  policy_id = newrelic_alert_policy.lcert_pkbox_synth_policy.id

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

  policy_id = newrelic_alert_policy.lcert_pkbox_synth_policy.id

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

  policy_id = newrelic_alert_policy.lcert_pkbox_synth_policy.id

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

  policy_id = newrelic_alert_policy.lcert_pkbox_synth_policy.id

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

  policy_id = newrelic_alert_policy.lcert_pkbox_synth_policy.id

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
