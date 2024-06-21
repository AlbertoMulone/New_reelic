# policy
resource "newrelic_alert_policy" "lcert_jblcert_policy" {
  name = "lcert ${var.env} jblcert policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} jblcert"
  policy_id    = newrelic_alert_policy.lcert_jblcert_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source    = "../infra"
  policy_id = newrelic_alert_policy.lcert_jblcert_policy.id
  filter    = "( `service_name` = '${var.service_name}' AND `environment` IN ('${join("', '", var.network_envs)}') )"
  enabled   = var.enabled
}

# alert
module "jboss6" {
  source = "../jboss6"

  alert_policy_id = newrelic_alert_policy.lcert_jblcert_policy.id
  network_envs    = var.network_envs
  jboss_instances = var.jblcert_services
  service_name    = var.service_name
}
