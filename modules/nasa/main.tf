# variables
locals {
  complete_appname = "${var.basename}_${var.label}_${var.env}"
}

# policy
resource "newrelic_alert_policy" "lcert_nasa_policy" {
  name = "lcert ${var.env} ${var.basename} ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ${var.basename} ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_nasa_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source    = "../infra"
  policy_id = newrelic_alert_policy.lcert_nasa_policy.id
  filter    = "( `apmApplicationNames` like '%|${local.complete_appname}|%' )"
  enabled   = var.enabled
}

# alert
module "java-microservice" {
  source             = "../java-microservice"
  alert_policy_id    = newrelic_alert_policy.lcert_nasa_policy.id
  enabled            = var.enabled
  complete_appname   = local.complete_appname
  health_aggr_window = 60
  health_aggr_method = "event_timer"
  health_aggr_timer  = 60
  health_exp_duration = 900
  health_fill_option = "none"
  nodata_aggr_window = 60
}

# synthetics
module "nasa_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_nasa_policy.id
  product   = var.basename
}