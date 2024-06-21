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

# infra
module "k8s_infra" {
  source = "../infra-k8s"

  policy_id                 = newrelic_alert_policy.lcert_app_policy.id
  filter                    = "( `namespaceName` = '${var.namespaceName}' AND `deploymentName` = '${var.deploymentName}' )"
  high_memory_usage_percent = 95
  enabled                   = var.enabled
}

# APM
module "apm_v2" {
  source = "../apm_v2"

  policy_id     = newrelic_alert_policy.lcert_app_policy.id
  filter_app    = "( `appName` = '${local.complete_appname}' )"
  filter_trnsct = "( `appName` = '${local.complete_appname}' AND `transactionType` = 'Web' AND `httpResponseCode` NOT LIKE '4%' AND `request.uri` != '/health/ready' )"
  enabled       = var.enabled

  enable_APM_duration_check = var.enable_APM_duration_check
  enable_APM_failure_check  = var.enable_APM_failure_check
  failure_thresh_crt        = var.failure_thresh_crt
  failure_thresh_duration   = var.failure_thresh_duration
  failure_slide_by          = var.failure_slide_by 
  #enable_APM_apdex_check    = var.enable_APM_apdex_check
  #apdex_thresh_crt          = var.apdex_thresh_check

}

# synthetics
module "ernst_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_app_policy.id
  product   = var.basename
}