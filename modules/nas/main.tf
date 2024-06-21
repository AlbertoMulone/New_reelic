# policy
resource "newrelic_alert_policy" "lcert_nas_policy" {
  name                = "lcert ${var.env} nas policy"
  incident_preference = "PER_CONDITION_AND_TARGET"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} nas"
  policy_id    = newrelic_alert_policy.lcert_nas_policy.id
  notification = var.notification
}

# CDAM marche check
resource "newrelic_nrql_alert_condition" "lcert_nas_marche_CDAM_check" {
  count = var.enable_CDAM_check ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_nas_policy.id

  name    = "dir count marche CDAM"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 2400
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT latest(DIR_QTY)
FROM CDAM_marche_Sample
WHERE `environment` = '${var.env}'
FACET `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = var.marche_cdam_thresh
    threshold_duration    = 1800
    threshold_occurrences = "all"
  }

}

# no data
resource "newrelic_nrql_alert_condition" "lcert_nas_marche_CDAM_no_data" {
  count = var.enable_CDAM_check ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_nas_policy.id

  name    = "dir count marche CDAM no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 3000
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  slide_by           = 60

  violation_time_limit_seconds = 2592000
  expiration_duration          = 3000
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM CDAM_marche_Sample
WHERE `environment` = '${var.env}'
FACET `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 3000
    threshold_occurrences = "at_least_once"
  }
}

# NFS disks: used percentage
resource "newrelic_nrql_alert_condition" "lcert_nas_disk_used_check" {
  policy_id = newrelic_alert_policy.lcert_nas_policy.id

  name    = "NFS disks used percentage > ${var.disk_used_thresh}%"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1200
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT latest(diskUsedPercent)
FROM NFSSample
WHERE `environment` IN ('${join("', '", var.network_envs)}')
FACET `fullHostname`, `mountPoint`, `device`, `team`, `environment`, `datacenter`
EOF

  }

  critical {
    operator              = "above"
    threshold             = var.disk_used_thresh
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}
