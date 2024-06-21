# policy
resource "newrelic_alert_policy" "lcert_icsscore_policy" {
  name = "lcert ${var.env} icsscore ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} icsscore ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_icsscore_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source = "../infra"

  policy_id = newrelic_alert_policy.lcert_icsscore_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled
}

# process
resource "newrelic_infra_alert_condition" "icssd_not_running" {
  policy_id = newrelic_alert_policy.lcert_icsscore_policy.id

  name          = "icssd not running"
  type          = "infra_process_running"
  comparison    = "below"
  process_where = "`commandName` = 'icssd'"
  where         = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled       = var.enabled

  violation_close_timer = 72

  critical {
    duration = 5
    value    = var.process_count
  }
}

# ntpd
resource "newrelic_infra_alert_condition" "ntpd_not_running" {
  policy_id = newrelic_alert_policy.lcert_icsscore_policy.id

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
