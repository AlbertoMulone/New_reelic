# policy
resource "newrelic_alert_policy" "lcert_adss_policy" {
  name = "lcert ${var.env} adss ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} adss ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_adss_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_adss_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled

  violation_close_timer     = 72
  enable_fs_read_only       = true
  enable_host_not_reporting = length(regexall(".aws", var.env)) > 0 ? false : true
}

# process
resource "newrelic_infra_alert_condition" "tomcatd_core_not_running" {
  policy_id = newrelic_alert_policy.lcert_adss_policy.id

  name          = "tomcatd core not running (/usr/local/adss/jdk/bin/java)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`processDisplayName` = 'tomcatd_core_linux'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "tomcatd_service_not_running" {
  policy_id = newrelic_alert_policy.lcert_adss_policy.id

  name          = "tomcatd service not running (/usr/local/adss/jdk/bin/java)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`processDisplayName` = 'tomcatd_service_linux'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}


resource "newrelic_infra_alert_condition" "tomcatd_console_not_running" {
  policy_id = newrelic_alert_policy.lcert_adss_policy.id

  name          = "tomcatd console not running (/usr/local/adss/jdk/bin/java)"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`processDisplayName` = 'tomcatd_console_linux'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}

resource "newrelic_infra_alert_condition" "ntpd_not_running" {
  count = length(regexall(".aws", var.env)) > 0 ? 0 : 1

  policy_id = newrelic_alert_policy.lcert_adss_policy.id

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

resource "newrelic_infra_alert_condition" "chronyd_not_running" {
  count = length(regexall(".aws", var.env)) > 0 ? 1 : 0

  policy_id = newrelic_alert_policy.lcert_adss_policy.id

  name          = "chronyd not running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "`commandName` = 'chronyd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = 0
  }
}
