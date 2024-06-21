# variables
locals {
  complete_appname = "${var.basename}_${var.env}"
}

# policy
resource "newrelic_alert_policy" "lcert_app_policy" {
  name = "lcert ${var.env} ${var.basename} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ${var.basename}"
  policy_id    = newrelic_alert_policy.lcert_app_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source    = "../infra"
  policy_id = newrelic_alert_policy.lcert_app_policy.id
  filter    = "( `apmApplicationNames` like '%|${local.complete_appname}|%' )"
  enabled   = var.enabled
}

# alert
module "java-microservice" {
  source           = "../java-microservice"
  alert_policy_id  = newrelic_alert_policy.lcert_app_policy.id
  enabled          = var.enabled
  complete_appname = local.complete_appname
  health_aggr_delay   = var.health_aggr_delay
  health_threshold    = var.health_threshold
  health_th_duration  = var.health_th_duration
  health_th_occurence = var.health_th_occurence  
}

# synthetics
module "wormhole_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_app_policy.id
  product   = "WORMHOLE"
}
