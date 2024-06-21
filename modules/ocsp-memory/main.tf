# policy
resource "newrelic_alert_policy" "lcert_ocsp_memory_policy" {
  name = "lcert ${var.env} ocsp memory policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ocsp memory"
  policy_id    = newrelic_alert_policy.lcert_ocsp_memory_policy.id
  notification = var.notification
}

# alert
resource "newrelic_infra_alert_condition" "lcert_ocsp_high_memory_usage" {
  policy_id = newrelic_alert_policy.lcert_ocsp_memory_policy.id

  name       = "high memory usage"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "memoryUsedPercent"
  comparison = "above"
  where      = <<EOF
`service_name` IN ('${join("', '", var.service_names)}')
AND `environment` IN ('${join("', '", var.network_envs)}')
EOF

  enabled               = var.enabled
  violation_close_timer = 72

  critical {
    duration      = 15
    value         = 85
    time_function = "all"
  }
}
