# variables
locals {
  complete_appname = "${var.basename}_${var.label}_${var.env}"
}

# policy
resource "newrelic_alert_policy" "lcert_app_policy" {
  name = "lcert ${var.env} ${var.basename} ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ${var.basename} ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_app_policy.id
  notification = var.notification
}

# see-sock-serv process not running
resource "newrelic_infra_alert_condition" "process_not_running" {
  policy_id = newrelic_alert_policy.lcert_app_policy.id

  name                  = "see-sock-serv process not running"
  type                  = "infra_process_running"
  comparison            = "equal"
  where                 = "(hostname LIKE '${var.hostname_filter}%')"
  process_where         = "commandName = 'see-sock-serv'"
  enabled               = var.enabled

  violation_close_timer = 72

  critical {
    duration      = 5
    value         = 0
  }
}

# ping
resource "newrelic_infra_alert_condition" "host_not_reporting" {
  policy_id = newrelic_alert_policy.lcert_app_policy.id

  name                  = "host not reporting"
  type                  = "infra_host_not_reporting"
  where                 = "(hostname LIKE '${var.hostname_filter}%')"
  enabled               = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
  }
}

# cpu
resource "newrelic_infra_alert_condition" "high_cpu" {
  policy_id = newrelic_alert_policy.lcert_app_policy.id

  name                  = "high cpu usage"
  type                  = "infra_metric"
  event                 = "ProcessSample"
  select                = "cpuPercent"
  comparison            = "above"
  where                 = "(hostname LIKE '${var.hostname_filter}%')"
  enabled               = var.enabled

  violation_close_timer = 72

  critical {
    duration            = 15
    value               = 90
    time_function       = "all"
  }
}

# disk
resource "newrelic_infra_alert_condition" "high_disk_usage" {
  policy_id = newrelic_alert_policy.lcert_app_policy.id

  name                  = "high disk usage"
  type                  = "infra_metric"
  event                 = "StorageSample"
  select                = "diskUsedPercent"
  comparison            = "above"
  where                 = "(hostname LIKE '${var.hostname_filter}%')"
  enabled               = var.enabled

  violation_close_timer = 72

  critical {
    duration            = 15
    value               = 90
    time_function       = "all"
  }

}

# memory
resource "newrelic_infra_alert_condition" "high_memory_usage" {
  policy_id = newrelic_alert_policy.lcert_app_policy.id

  name                  = "high memory usage"
  type                  = "infra_metric"
  event                 = "SystemSample"
  select                = "memoryUsedPercent"
  comparison            = "above"
  where                 = "(hostname LIKE '${var.hostname_filter}%')"
  enabled               = var.enabled

  violation_close_timer = 72

  critical {
    duration            = 15
    value               = 90
    time_function       = "all"
  }
}

# synthetics
module "triss_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_app_policy.id
  product   = "TRISSQ"
}