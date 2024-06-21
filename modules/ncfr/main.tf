/*
locals {
  complete_appname = "${var.basename}_${var.label}_${var.env}"
}

resource "newrelic_synthetics_monitor" "lcert_FirmFR" {
  name      = "lcert_FirmFR"
  type      = "SIMPLE"
  frequency = 15
  status    = "ENABLED"
  locations = ["AWS_EU_WEST_1"]

  uri        = "https://ncfrcl.infocert.it/ncfr-webservice/FirmaFR?wsdl"
  verify_ssl = true
}

resource "newrelic_synthetics_monitor" "lcert_GenCertFR" {
  name      = "lcert_GenCertFR"
  type      = "SIMPLE"
  frequency = 15
  status    = "ENABLED"
  locations = ["AWS_EU_WEST_1"]

  uri        = "https://ncfrcl.infocert.it/ncfr-webservice/GenCertFR?wsdl"
  verify_ssl = true
}

resource "newrelic_synthetics_monitor" "lcert_GenCertMedWS" {
  name      = "lcert_GenCertMedWS"
  type      = "SIMPLE"
  frequency = 15
  status    = "ENABLED"
  locations = ["AWS_EU_WEST_1"]

  uri        = "https://ncfrcl.infocert.it/ncfr-webservice/GenCertMedWS?wsdl"
  verify_ssl = true
}

resource "newrelic_synthetics_monitor" "lcert_RegCertFR" {
  name      = "lcert_RegCertFR"
  type      = "SIMPLE"
  frequency = 15
  status    = "ENABLED"
  locations = ["AWS_EU_WEST_1"]

  uri        = "https://ncfrcl.infocert.it/ncfr-webservice/RegCertFR?wsdl"
  verify_ssl = true
}

resource "newrelic_synthetics_monitor" "lcert_OTPSender" {
  name      = "lcert_OTPSender"
  type      = "SIMPLE"
  frequency = 15
  status    = "ENABLED"
  locations = ["AWS_EU_WEST_1"]

  uri        = "https://ncfrcl.infocert.it/ncfr-webservice/OTPSender?wsdl"
  verify_ssl = true
}
*/

resource "newrelic_alert_policy" "lcert_ncfr_policy" {
  name = "lcert ${var.env} ncfr ${var.label} policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ncfr ${var.label}"
  policy_id    = newrelic_alert_policy.lcert_ncfr_policy.id
  notification = var.notification
}

# ncfr apache elapsed: 95° percentile > 2
resource "newrelic_nrql_alert_condition" "ncfr_apache_elapsed_check" {
  for_each = var.enable_apache_checks ? var.apache_checks_info : {}

  policy_id = newrelic_alert_policy.lcert_ncfr_policy.id

  name    = "ncfr ${each.value.net_env} apache log - elapsed check"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60
  fill_option        = "last_value"

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 900
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT percentile(numeric(elapsed),95)
FROM Log
WHERE `tag` = '${each.value.tag}'
EOF

  }
  // error when 95 percentile of elapsed is over threshold for 15 minutes
  critical {
    operator              = "above"
    threshold             = each.value.elaps_thresh
    threshold_duration    = 900
    threshold_occurrences = "all"
  }
}

# APM
module "apm_v2" {
  source = "../apm_v2"

  policy_id     = newrelic_alert_policy.lcert_ncfr_policy.id
  filter_app    = "( `appName` = 'ncfr_infocert_${var.env}' )"
  filter_trnsct = "( `appName` = 'ncfr_infocert_${var.env}' AND `name` NOT LIKE '%default%' AND `transactionType` = 'Web' AND `httpResponseCode` NOT IN ('401','405','404','400','304'))"
  filter_split_dur = true
  filter_trnsct_dur = "( `appName` = 'ncfr_infocert_${var.env}' AND `name` NOT LIKE '%default%' AND `transactionType` = 'Web' AND `httpResponseCode` NOT LIKE '4%' AND `name` IN ('WebTransaction/Servlet/ServerMaRe','WebTransaction/Servlet/FirmaFR','WebTransaction/Servlet/OTPSender','WebTransaction/Servlet/FirmaWS','WebTransaction/Servlet/GenCertFR','WebTransaction/Servlet/RegCertFR'))"
  enabled       = var.enabled

  enable_APM_duration_check = var.enable_APM_duration_check
  duration_thresh_crt       = var.duration_thresh_crt
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
  duration_thresh_duration  = var.duration_thresh_duration
  duration_aggregation_delay  = var.duration_aggregation_delay
  duration_aggregation_window = var.duration_aggregation_window
  duration_slide_by           = var.duration_slide_by
}

# synthetics
module "ncfr_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_ncfr_policy.id
  product   = "NCFR"
}
