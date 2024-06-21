locals {
  frequency = {
    "EVERY_MINUTE"     = 60,
    "EVERY_5_MINUTES"  = 300,
    "EVERY_10_MINUTES" = 600,
    "EVERY_15_MINUTES" = 900,
    "EVERY_30_MINUTES" = 1800,
    "EVERY_HOUR"       = 3600,
    "EVERY_6_HOURS"    = 21600,
    "EVERY_12_HOURS"   = 43200,
    "EVERY_DAY"        = 86000
  }
}

# private location
data "newrelic_synthetics_private_location" "legalcert_mgmt" {
  name = "LegalCert MGMT"
}

data "newrelic_synthetics_private_location" "legalcert_mgmt_ca" {
  name = "LegalCert MGMT CA"
}

# private location w/updated runtimes
data "newrelic_synthetics_private_location" "legalcert_mgmt_jobmanager" {
  name = "LegalCert MGMT JobManager"
}

data "aws_secretsmanager_secret_version" "newrelic" {
  secret_id = "newrelic"
}

locals {
  newrelic_secret = jsondecode(data.aws_secretsmanager_secret_version.newrelic.secret_string)
}

# newrelic synthetics monitor
resource "newrelic_synthetics_monitor" "monitor" {
  count = var.type == "SIMPLE" ||  var.type == "BROWSER" ? 1 : 0

  status = var.enabled ? "ENABLED" : "DISABLED"
  name   = var.name
  period = var.period
  type   = var.type
  uri    = var.url

  locations_private = var.private ? var.private_dc ? var.private_dc_jobmanager ? [data.newrelic_synthetics_private_location.legalcert_mgmt_jobmanager.id] : [data.newrelic_synthetics_private_location.legalcert_mgmt.id] : [data.newrelic_synthetics_private_location.legalcert_mgmt_ca.id] : null
  locations_public  = !var.private ? var.locations_public : null

  validation_string = var.validation_string
  verify_ssl        = var.verify_ssl

  dynamic "tag" {
    for_each = var.tags

    content {
      key   = tag.key
      values = [tag.value]
    }
  }
}

# newrelic synthetics script monitor
resource "newrelic_synthetics_script_monitor" "script_monitor" {
  count = var.type == "SCRIPT_API" ||  var.type == "SCRIPT_BROWSER" ? 1 : 0

  status = var.enabled ? "ENABLED" : "DISABLED"
  name   = var.name
  period = var.period
  type   = var.type

  dynamic "location_private" {
    for_each = var.private ? [1] : []

    content {
      guid = var.private_dc ? var.private_dc_jobmanager ? data.newrelic_synthetics_private_location.legalcert_mgmt_jobmanager.id : data.newrelic_synthetics_private_location.legalcert_mgmt.id : data.newrelic_synthetics_private_location.legalcert_mgmt_ca.id
      vse_password = local.newrelic_secret.synthetic_private_password
    }
  }
  locations_public  = !var.private ? var.locations_public : null

  script          = templatefile(var.script_file, {params_map = var.params_map})
  script_language = var.script_language
  runtime_type    = var.runtime_type

  dynamic "tag" {
    for_each = var.tags

    content {
      key   = tag.key
      values = [tag.value]
    }
  }
}

# nrql check alerts
resource "newrelic_nrql_alert_condition" "result_check" {
  count = !var.disabled_result_check ? 1 : 0

  policy_id = var.policy_id

  name    = "synthetics result check ${var.label}"
  type    = "static"
  enabled = true

  // window
  // manual:
  //   var.result_window
  // auto:
  //   private location = 3 * frequency + 5 minutes ( =3 check in window)
  //   public  location = 2 * frequency + 5 minutes (>=4 check in window)
  aggregation_window = coalesce(var.result_window,
    var.private || length(var.locations_public) == 1 ? lookup(local.frequency, var.period, "") * 3 + 300 :  lookup(local.frequency, var.period, "") * 2 + 300
  )
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  fill_option        = "last_value"
  slide_by           = 60

  // will close after 30 days
  violation_time_limit_seconds   = 2592000
  expiration_duration            = coalesce(var.result_expiration, coalesce(var.result_window,
    var.private || length(var.locations_public) == 1 ? lookup(local.frequency, var.period, "") * 3 + 300 :  lookup(local.frequency, var.period, "") * 2 + 300
  ))
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `result` != 'SUCCESS'
AND `monitorName` = '${var.type == "SIMPLE" ||  var.type == "BROWSER" ? newrelic_synthetics_monitor.monitor[0].name : newrelic_synthetics_script_monitor.script_monitor[0].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF
  }
  // 1 location (private or public with only 1)
  //    =3 checks every window
  //   error when 2/3 in window
  // >2 location (public)
  //   >=4 checks every window
  //   error when 3/(>=4) in window
  critical {
    operator              = "above"
    threshold             = coalesce(var.result_threshold, var.private || length(var.locations_public) == 1 ? 1 : 2)
    threshold_duration    = coalesce(var.result_threshold_duration, coalesce(var.result_window,
      var.private || length(var.locations_public) == 1 ? lookup(local.frequency, var.period, "") * 3 + 300 :  lookup(local.frequency, var.period, "") * 2 + 300
    ))
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "duration_check" {
  count = !var.disabled_duration_check ? 1 : 0

  policy_id = var.policy_id

  name    = "synthetics duration check ${var.label}"
  type    = "static"
  enabled = true

  // window
  // manual:
  //   var.duration_window
  // auto:
  //   private location = 3 * frequency + 5 minutes ( =3 check in window)
  //   public  location = 2 * frequency + 5 minutes (>=4 check in window)
  aggregation_window = coalesce(var.duration_window,
    var.private || length(var.locations_public) == 1 ? lookup(local.frequency, var.period, "") * 3 + 300 :  lookup(local.frequency, var.period, "") * 2 + 300
  )
  aggregation_method = "event_flow"
  aggregation_delay  = 60
  fill_option        = "last_value"
  slide_by           = 60

  // will close after 30 days
  violation_time_limit_seconds   = 2592000
  expiration_duration            = coalesce(var.duration_expiration, coalesce(var.duration_window,
    var.private || length(var.locations_public) == 1 ? lookup(local.frequency, var.period, "") * 3 + 300 :  lookup(local.frequency, var.period, "") * 2 + 300
  ))
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `duration` > ${coalesce(var.duration_timeout, 2000)}
AND `monitorName` = '${var.type == "SIMPLE" ||  var.type == "BROWSER" ? newrelic_synthetics_monitor.monitor[0].name : newrelic_synthetics_script_monitor.script_monitor[0].name}'
FACET `tags.brand`, `tags.team`, `tags.environment`, `tags.technical_service`
EOF
  }
  // 1 location (private or public with only 1)
  //    =3 checks every window
  //   error when 2/3 in window
  // >2 location (public)
  //   >=4 checks every window
  //   error when 3/(>=4) in window
  critical {
    operator              = "above"
    threshold             = coalesce(var.duration_threshold, var.private || length(var.locations_public) == 1 ? 1 : 2)
    threshold_duration    = coalesce(var.duration_threshold_duration, coalesce(var.duration_window,
      var.private || length(var.locations_public) == 1 ? lookup(local.frequency, var.period, "") * 3 + 300 :  lookup(local.frequency, var.period, "") * 2 + 300
    ))
    threshold_occurrences = "at_least_once"
  }
}

resource "newrelic_nrql_alert_condition" "nodata_check" {
  count = !var.disabled_nodata_check && lookup(local.frequency, var.period, "") <= 1800 ? 1 : 0

  policy_id = var.policy_id

  name    = "synthetics no data check ${var.label}"
  type    = "static"
  enabled = true

  // window
  aggregation_window = 3600            // 1 hours
  aggregation_method = "event_flow"
  aggregation_delay  = 900             // 15 min
  fill_option        = "last_value"

  // will close after 30 days
  violation_time_limit_seconds = 2592000
  expiration_duration          = 86400 // 24 hours
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM SyntheticCheck
WHERE `monitorName` = '${var.type == "SIMPLE" ||  var.type == "BROWSER" ? newrelic_synthetics_monitor.monitor[0].name : newrelic_synthetics_script_monitor.script_monitor[0].name}'
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
