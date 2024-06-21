# variables
locals {
  complete_appname = "${var.basename}_${var.label}_${var.env}"
}

resource "newrelic_alert_policy" "lcert_nova_policy" {
  name = "lcert ${var.env} ${var.basename} ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ${var.basename} ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_nova_policy.id
  notification = var.notification
}

# infra
module "infra" {
  source                    = "../infra"
  policy_id                 = newrelic_alert_policy.lcert_nova_policy.id
  filter                    = "( `apmApplicationNames` like '%|${local.complete_appname}|%' )"
  enabled                   = var.enabled
  high_memory_usage_percent = 95
  // TODO Patch for high cpu usage and multicore software. Temporary!
  high_cpu_usage_percent = 300
}

# alert
module "java-microservice" {
  source           = "../java-microservice"
  alert_policy_id  = newrelic_alert_policy.lcert_nova_policy.id
  enabled          = var.enabled
  complete_appname = local.complete_appname
  health_aggr_delay   = var.health_aggr_delay
  health_threshold    = var.health_threshold
  health_th_duration  = var.health_th_duration
  health_th_occurence = var.health_th_occurence
}

# nagios
/*
resource "newrelic_nrql_alert_condition" "response_time" {
  policy_id = newrelic_alert_policy.lcert_nova_policy.id

  name    = "response time"
  type    = "static"
  enabled = var.enabled
  
  violation_time_limit_seconds   = 2592000
  expiration_duration            = 600
  close_violations_on_expiration = true

  nrql {
    query       = <<EOF
SELECT percentile(duration,75) FROM Transaction WHERE appName = '${local.complete_appname}'   and request.headers.host NOT LIKE'%8080' and request.headers.host is NOT NULL
EOF

    evaluation_offset = "3"
  }

  critical {
    operator      = "above"
    threshold     = "2"
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
}
*/

# APM
module "apm_v2" {
  source = "../apm_v2"

  policy_id     = newrelic_alert_policy.lcert_nova_policy.id
  filter_app    = "( `appName` = '${local.complete_appname}' )"
  filter_trnsct = "( `appName` = '${local.complete_appname}' AND `transactionType` = 'Web' AND `name` LIKE '%nova%' AND `httpResponseCode` NOT LIKE '4%' AND `request.uri` != '/favicon.ico' AND `request.uri` != '/health/ready' )"
  enabled       = var.enabled

  enable_APM_duration_check = var.enable_APM_duration_check
  enable_APM_failure_check  = var.enable_APM_failure_check
  failure_thresh_crt        = var.failure_thresh_crt
  failure_thresh_duration   = var.failure_thresh_duration
  failure_slide_by          = var.failure_slide_by
  enable_APM_db_check       = var.enable_APM_db_check
  db_resp_time_thresh       = var.db_resp_time_thresh
  db_type                   = var.db_type
  db_transaction_type       = var.db_transaction_type
  enable_APM_apdex_check    = var.enable_APM_apdex_check
  apdex_thresh_crt          = var.apdex_thresh
  apdex_thresh_duration     = var.apdex_thresh_duration
}

# synthetics
module "nova_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_nova_policy.id
  product   = "NOVA"
}