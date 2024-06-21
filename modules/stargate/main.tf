# policy
resource "newrelic_alert_policy" "lcert_stargate_policy" {
  name = "lcert ${var.env} stargate ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} stargate ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_stargate_policy.id
  notification = var.notification
}

# infra
module "k8s_infra" {
  source = "../infra-k8s"

  policy_id             = newrelic_alert_policy.lcert_stargate_policy.id
  filter                = "( `clusterName` = '${var.clusterName}' AND `deploymentName` = '${var.deploymentName}' )"
  enabled               = var.enabled
  enable_fs_usage_check = false
}

# log
resource "newrelic_nrql_alert_condition" "stargate_check_log" {
  policy_id = newrelic_alert_policy.lcert_stargate_policy.id

  name    = "stargate check log"
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

  # TODO add FACET environment
  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM Log
WHERE `cluster_name` LIKE '%/${var.clusterName}'
AND `pod_name` LIKE '${var.deploymentName}%'
AND (`message` LIKE '%ERROR%') OR (`message` LIKE '%WARN%' AND (`message` LIKE '%timeout%' OR `message` LIKE '%failed%' OR `message` LIKE '%error%'))
EOF
  }

  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 300
    threshold_occurrences = "at_least_once"
  }
}


# alignment caroots
resource "newrelic_nrql_alert_condition" "stargate_check_alignment_caroots" {
  policy_id = newrelic_alert_policy.lcert_stargate_policy.id

  name    = "compliance stargate check alignment caroots"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 5400
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 5400
  close_violations_on_expiration = true

  # TODO add FACET environment
  nrql {
    query = <<EOF
SELECT count(*) 
FROM StargateSample 
WHERE `table` = 'caroots'
AND `release` = '${var.labels_release}' 
AND `environment` = '${var.env}'
AND (from_count - to_count) >= 1    
EOF
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 5400
    threshold_occurrences = "at_least_once"
  }
}

# alignment issuedcertificates
resource "newrelic_nrql_alert_condition" "stargate_check_alignment_issuedcertificates" {
  policy_id = newrelic_alert_policy.lcert_stargate_policy.id

  name    = "compliance stargate check alignment issuedcertificates"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 5400
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 5400
  close_violations_on_expiration = true

  # TODO add FACET environment
  nrql {
    query = <<EOF
SELECT count(*) 
FROM StargateSample 
WHERE `table` = 'issuedcertificates'
AND `release` = '${var.labels_release}' 
AND `environment` = '${var.env}'
AND (from_count - to_count) >= 1
EOF
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 5400
    threshold_occurrences = "at_least_once"
  }
}

# alignment revokedcertificates
resource "newrelic_nrql_alert_condition" "stargate_check_alignment_revokedcertificates" {
  policy_id = newrelic_alert_policy.lcert_stargate_policy.id

  name    = "compliance stargate check alignment revokedcertificates"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 5400
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 5400
  close_violations_on_expiration = true

  # TODO add FACET environment
  nrql {
    query = <<EOF
SELECT count(*) 
FROM StargateSample 
WHERE `table` = 'revokedcertificates'
AND `release` = '${var.labels_release}' 
AND `environment` = '${var.env}'
AND (from_count - to_count) >= 1
EOF
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 5400
    threshold_occurrences = "at_least_once"
  }
}

# no data
resource "newrelic_nrql_alert_condition" "stargate_alignment_no_data" {
  policy_id = newrelic_alert_policy.lcert_stargate_policy.id

  name    = "compliance stargate alignment no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 7200
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 60

  violation_time_limit_seconds = 2592000
  expiration_duration          = 7200
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*) 
FROM StargateSample 
WHERE `release` = '${var.labels_release}' 
AND `environment` = '${var.env}'
FACET `table`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 7200
    threshold_occurrences = "at_least_once"
  }
}
