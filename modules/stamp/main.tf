# policy
resource "newrelic_alert_policy" "lcert_stamp_policy" {
  name = "lcert ${var.env} stamp policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} stamp"
  policy_id    = newrelic_alert_policy.lcert_stamp_policy.id
  notification = var.notification
}

# STAMP Milan probe checks: PING
resource "newrelic_nrql_alert_condition" "lcert_stamp_probe_checks_PING" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_stamp_policy.id

  name    = "STAMP probe checks: PING"
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
SELECT count(*)
FROM STAMP_Sample
WHERE `PING` != 'Ping OK'
AND `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // 1 check every 5 minutes
  // Alert if 3/3 consecutive checks fail within 20 min time window
  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}

# STAMP Milan probe checks: MARCHE
resource "newrelic_nrql_alert_condition" "lcert_stamp_probe_checks_MARCHE" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_stamp_policy.id

  name    = "STAMP probe checks: MARCHE"
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
SELECT count(*)
FROM STAMP_Sample
WHERE `MARCHE` != 'Marche OK'
AND `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // 1 check every 5 minutes
  // Alert if 3/3 consecutive checks fail within 20 min time window
  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}

# STAMP Milan probe checks: TS COLOMBIA
resource "newrelic_nrql_alert_condition" "lcert_stamp_probe_checks_TS_COLOMBIA" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_stamp_policy.id

  name    = "STAMP probe checks: TS USER COLOMBIA"
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
SELECT count(*)
FROM STAMP_Sample
WHERE `TS_USER_COLOMBIA` != 'TS User Colombia OK'
AND `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // 1 check every 5 minutes
  // Alert if 3/3 consecutive checks fail within 20 min time window
  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}

# STAMP Milan probe checks: TS INT
resource "newrelic_nrql_alert_condition" "lcert_stamp_probe_checks_TS_INT" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_stamp_policy.id

  name    = "STAMP probe checks: TS USER INTERNAL"
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
SELECT count(*)
FROM STAMP_Sample
WHERE `TS_USER_INT` != 'TS User Int OK'
AND `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // 1 check every 5 minutes
  // Alert if 3/3 consecutive checks fail within 20 min time window
  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}

# STAMP Milan probe checks: TS PERU
resource "newrelic_nrql_alert_condition" "lcert_stamp_probe_checks_TS_PERU" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_stamp_policy.id

  name    = "STAMP probe checks: TS USER PERU"
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
SELECT count(*)
FROM STAMP_Sample
WHERE `TS_USER_PERU` != 'TS User Peru OK'
AND `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // 1 check every 5 minutes
  // Alert if 3/3 consecutive checks fail within 20 min time window
  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}

# STAMP Milan probe checks: TS SPAGNA
resource "newrelic_nrql_alert_condition" "lcert_stamp_probe_checks_TS_SPAGNA" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_stamp_policy.id

  name    = "STAMP probe checks: TS USER SPAGNA"
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
SELECT count(*)
FROM STAMP_Sample
WHERE `TS_USER_SPAGNA` != 'TS User Spagna OK'
AND `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // 1 check every 5 minutes
  // Alert if 3/3 consecutive checks fail within 20 min time window
  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}

# STAMP Milan probe checks: TS UNLIMITED
resource "newrelic_nrql_alert_condition" "lcert_stamp_probe_checks_TS_UNL" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_stamp_policy.id

  name    = "STAMP probe checks: TS USER UNLIMITED"
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
SELECT count(*)
FROM STAMP_Sample
WHERE `TS_USER_UNL` != 'TS User Unlmt OK'
AND `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // 1 check every 5 minutes
  // Alert if 3/3 consecutive checks fail within 20 min time window
  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 1200
    threshold_occurrences = "at_least_once"
  }
}

# STAMP Milan probe no data
resource "newrelic_nrql_alert_condition" "lcert_stamp_probe_no_data" {
  count = var.enable_probe ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_stamp_policy.id

  name    = "STAMP probe no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 1800
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  slide_by           = 60

  violation_time_limit_seconds = 2592000
  expiration_duration          = 1800
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM STAMP_Sample
WHERE `environment` = '${var.env}'
FACET `environment`, `brand`, `team`, `technical_service`
EOF

  }
  // No data alert if no signals received for 30 min
  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 1800
    threshold_occurrences = "at_least_once"
  }

}

# infra
module "k8s_infra" {
  source = "../infra-k8s"

  policy_id                 = newrelic_alert_policy.lcert_stamp_policy.id
  filter                    = "( `clusterName` = '${var.clusterName}' AND `deploymentName` = '${var.deploymentName}' )"
  high_memory_usage_percent = 95
  enabled                   = var.enabled
}

# replicaset STAMP-ADMIN
resource "newrelic_infra_alert_condition" "replicaset_not_desired_pods_stamp-admin" {
  policy_id = newrelic_alert_policy.lcert_stamp_policy.id

  name       = "STAMP-ADMIN: replicaset does not have desired amount of pods"
  type       = "infra_metric"
  event      = "K8sReplicaSetSample"
  select     = "podsMissing"
  comparison = "above"
  where      = "( `clusterName` = '${var.clusterName}' AND `deploymentName` = 'stamp-admin-${var.env}-service' )"
  enabled    = var.enabled

  violation_close_timer = 72

  critical {
    duration      = 5
    value         = 0
    time_function = "all"
  }
}

# STAMP Milan - Services: Avg response time 
resource "newrelic_nrql_alert_condition" "lcert_stamp_milan_pods_services_checks" {
  count = var.enable_milan_checks ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_stamp_policy.id

  name    = "STAMP services response time"
  type    = "static"
  enabled = var.enable_log_checks

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 1200
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT average(numeric(Elapsed)) AS 'Avg Resp Time'
FROM Log
WHERE `container_name` = 'stamp'
AND `cluster_name` = '${var.clusterName}'
AND `Service` IS NOT NULL
FACET `Service`
EOF

  }
  // Alert if any service has avg resp time > 10s
  critical {
    operator              = "above"
    threshold             = 10000
    threshold_duration    = 1200
    threshold_occurrences = "all"
  }
}

# STAMP Milan - APM
module "apm_v2" {
  source = "../apm_v2"

  policy_id     = newrelic_alert_policy.lcert_stamp_policy.id
  filter_app    = "( `appName` = 'stamp_infocert_${var.env}' )"
  filter_trnsct = "(`appName` = 'stamp_infocert_${var.env}' AND `name` NOT LIKE '%/health/ready%' AND `name` NOT LIKE '%/health/live%' AND `name` NOT LIKE '%/health%' AND `name` NOT LIKE '%Threads/Count/New Relic Sampler Service/WaitedCount%' AND `name` NOT LIKE '%TransportDuration/App%' AND `name` NOT LIKE '%/@QuarkusError%' AND `transactionType` = 'Web' AND `httpResponseCode` NOT IN ('405','415','401'))"
  enabled       = var.enabled

  enable_APM_duration_check = var.enable_APM_duration_check
  duration_check_type       = var.duration_check_type
  duration_thresh_crt       = var.duration_thresh_crt
  duration_thresh_duration  = var.duration_thresh_duration
  enable_APM_failure_check  = var.enable_APM_failure_check
  failure_thresh_crt        = var.failure_thresh_crt
  failure_thresh_duration   = var.failure_thresh_duration
  enable_APM_db_check       = var.enable_APM_db_check
  db_resp_time_thresh       = var.db_resp_time_thresh
  db_type                   = var.db_type
  db_transaction_type       = var.db_transaction_type
  enable_APM_apdex_check    = var.enable_APM_apdex_check
  apdex_thresh_crt          = var.apdex_thresh
  failure_aggr_delay        = var.failure_aggr_delay
  failure_aggr_method       = var.failure_aggr_method
  failure_aggr_window       = var.failure_aggr_window
  failure_slide_by          = var.failure_slide_by
}

# carpediem degraded performance
resource "newrelic_nrql_alert_condition" "lcert_stamp_carpediem_dp" {
  policy_id     = newrelic_alert_policy.lcert_stamp_policy.id

  name    = "STAMP carpediem degraded performance"
  type    = "static"
  enabled = false

  aggregation_window = 60
  aggregation_method = "cadence"
  aggregation_delay  = 120
  slide_by           = 30

  violation_time_limit_seconds = 2592000
  expiration_duration          = 900
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT percentile(numeric(capture(message, r'.*= (?P<time>\d+).*')),99) AS `percentile`
FROM Log 
WHERE `container_name` = 'stamp' AND `cluster_name` = '${var.clusterName}' 
AND `message` like '%CARPE TOTAL%'
FACET `container_name`, `cluster_name`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "1000"
    threshold_duration    = 180
    threshold_occurrences = "all"
  }
}