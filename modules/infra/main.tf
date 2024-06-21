# ping
resource "newrelic_infra_alert_condition" "host_not_reporting" {
  policy_id = var.policy_id

  name    = "host not reporting"
  type    = "infra_host_not_reporting"
  where   = var.filter
  enabled = var.enabled ? var.enable_host_not_reporting : false

  violation_close_timer = var.violation_close_timer

  critical {
    duration = 5
  }
}

# cpu
resource "newrelic_infra_alert_condition" "high_cpu" {
  policy_id = var.policy_id

  name       = "high cpu usage"
  type       = "infra_metric"
  event      = "ProcessSample"
  select     = "cpuPercent"
  comparison = "above"
  where      = var.filter
  enabled    = var.enabled ? var.enable_high_cpu_usage : false

  violation_close_timer = var.violation_close_timer

  critical {
    duration      = var.high_cpu_usage_duration
    value         = var.high_cpu_usage_percent
    time_function = "all"
  }
}

# disk
resource "newrelic_infra_alert_condition" "high_disk_usage" {
  policy_id = var.policy_id

  name       = "high disk usage"
  type       = "infra_metric"
  event      = "StorageSample"
  select     = "diskUsedPercent"
  comparison = "above"
  where      = var.filter
  enabled    = var.enabled ? var.enable_high_disk_usage : false

  violation_close_timer = var.violation_close_timer

  critical {
    duration      = var.high_disk_usage_duration
    value         = var.high_disk_usage_percent
    time_function = "all"
  }

}

# memory
resource "newrelic_infra_alert_condition" "high_memory_usage" {
  policy_id = var.policy_id

  name       = "high memory usage"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "memoryUsedPercent"
  comparison = "above"
  where      = var.filter
  enabled    = var.enabled ? var.enable_high_memory_usage : false

  violation_close_timer = var.violation_close_timer

  critical {
    duration      = var.high_memory_usage_duration
    value         = var.high_memory_usage_percent
    time_function = "all"
  }
}

# filesystem read only
resource "newrelic_nrql_alert_condition" "filesystem_read_only" {
  count = var.enable_fs_read_only ? 1 : 0

  policy_id = var.policy_id

  name    = "filesystem read only"
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
FROM StorageSample
WHERE isReadOnly = 'true'
AND ${var.filter}
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

// inode
resource "newrelic_nrql_alert_condition" "high_disk_inode_usage" {
  count = var.enable_disk_inode_usage ? 1 : 0

  policy_id = var.policy_id

  name    = "high disk inode usage"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = var.high_disk_inode_usage_duration
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM StorageSample
WHERE `inodesUsedPercent` >= ${var.high_disk_inode_usage_percent}
AND ${var.filter}
FACET `fullHostname`, `mountPoint`, `brand`, `team`, `environment`, `technical_service`
EOF
  }

  critical {
    operator              = "above"
    threshold             = "0"
    threshold_duration    = var.high_disk_inode_usage_duration
    threshold_occurrences = "all"
  }
}
