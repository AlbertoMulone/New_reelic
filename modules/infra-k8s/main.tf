# cpu
resource "newrelic_nrql_alert_condition" "container_cpu_usage" {
  policy_id = var.policy_id

  name    = "container cpu usage % is too high"
  type    = "static"
  enabled = var.enabled

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT average(cpuCoresUtilization)
FROM K8sContainerSample
WHERE ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "above"
    threshold             = var.high_cpu_usage_percent
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# memory
resource "newrelic_nrql_alert_condition" "high_memory_usage" {
  policy_id = var.policy_id

  name    = "container memory usage % is too high"
  type    = "static"
  enabled = var.enabled

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT average(memoryWorkingSetUtilization)
FROM K8sContainerSample
WHERE ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "above"
    threshold             = var.high_memory_usage_percent
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# filesystem
resource "newrelic_nrql_alert_condition" "high_fs_usage" {
  policy_id = var.policy_id

  name    = "container is running out of space"
  type    = "static"
  enabled = var.enabled && var.enable_fs_usage_check

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM K8sContainerSample
WHERE `fsUsedPercent` > ${var.high_fs_usage_percent} AND ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# pod
resource "newrelic_nrql_alert_condition" "pod_was_unable_to_be_scheduled" {
  policy_id = var.policy_id

  name    = "pod was unable to be scheduled"
  type    = "static"
  enabled = var.enabled && var.enable_fs_usage_check

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT count(*)
FROM K8sPodSample
WHERE `isScheduled` = 0 AND ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# pod
resource "newrelic_nrql_alert_condition" "pod_is_not_ready" {
  policy_id = var.policy_id

  name    = "pod is not ready"
  type    = "static"
  enabled = var.enabled

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT count(*)
FROM K8sPodSample
WHERE `isReady` = 0 AND ${var.filter}
AND (`status` != 'Succeeded') AND (`status` != 'Failed')
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# replicaset
resource "newrelic_nrql_alert_condition" "replicaset_not_desired_pods" {
  policy_id = var.policy_id

  name    = "replicaset does not have desired amount of pods"
  type    = "static"
  enabled = var.enabled

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT count(*) 
FROM K8sReplicasetSample 
WHERE `podsMissing` > 0 AND ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# no data containersample
resource "newrelic_nrql_alert_condition" "container_no_data" {
  policy_id = var.policy_id

  name    = "container sample no data"
  type    = "static"
  enabled = var.enabled

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM K8sContainerSample
WHERE ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# no data podsample
resource "newrelic_nrql_alert_condition" "pod_no_data" {
  policy_id = var.policy_id

  name    = "pod sample no data"
  type    = "static"
  enabled = var.enabled

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM K8sPodSample
WHERE ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# no data replicaset
resource "newrelic_nrql_alert_condition" "replicaset_no_data" {
  policy_id = var.policy_id

  name    = "replicaset sample no data"
  type    = "static"
  enabled = var.enabled

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM K8sReplicasetSample
WHERE ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# containersample unknown status
resource "newrelic_nrql_alert_condition" "container_unknown_status" {
  policy_id = var.policy_id

  name    = "container sample unknown status"
  type    = "static"
  enabled = var.enabled

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM K8sContainerSample
WHERE `status` = 'Unknown' AND ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# containersample abnormal restartcount
resource "newrelic_nrql_alert_condition" "container_abnormal_restartcount" {
  policy_id = var.policy_id

  name    = "container sample abnormal restartcount"
  type    = "static"
  enabled = var.enabled

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM K8sContainerSample
WHERE `restartCount` > 5 AND ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}

# containersample OOM events
resource "newrelic_nrql_alert_condition" "container_oom_delta" {
  policy_id = var.policy_id

  name    = "container sample out of memory events"
  type    = "static"
  enabled = var.enabled

  violation_time_limit_seconds   = 2592000
  close_violations_on_expiration = true
  expiration_duration = 2100

  nrql {
    query = <<EOF
SELECT COUNT(*)
FROM K8sContainerSample
WHERE `containerOOMEventsDelta` > 0 AND ${var.filter}
FACET `label.Brand`, `label.Team`, `label.TechnicalService`
EOF
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 600
    threshold_occurrences = "at_least_once"
  }
}