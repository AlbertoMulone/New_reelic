# policy
resource "newrelic_alert_policy" "lcert_wcar_infora_policy" {
  name = "lcert ${var.env} wcar infora policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} wcar infora"
  policy_id    = newrelic_alert_policy.lcert_wcar_infora_policy.id
  notification = var.notification
}

# checks
resource "newrelic_nrql_alert_condition" "lcert_wcar_infora_check" {
  policy_id = newrelic_alert_policy.lcert_wcar_infora_policy.id

  name    = "wcar infora"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60

  violation_time_limit_seconds   = 2592000
  expiration_duration            = 300
  close_violations_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM WCARInfoRASample
WHERE `rc` > 0
AND `environment` = '${var.env}'
FACET `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

}

# no data
resource "newrelic_nrql_alert_condition" "lcert_wcar_infora_no_data" {
  policy_id = newrelic_alert_policy.lcert_wcar_infora_policy.id

  name    = "wcar infora no data"
  type    = "static"
  enabled = var.enabled

  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120

  violation_time_limit_seconds = 2592000
  expiration_duration          = 900
  open_violation_on_expiration = true

  nrql {
    query = <<EOF
SELECT count(*)
FROM WCARInfoRASample
WHERE `environment` = '${var.env}'
FACET `brand`, `team`, `environment`, `technical_service`
EOF

  }

  critical {
    operator              = "equals"
    threshold             = "0"
    threshold_duration    = 900
    threshold_occurrences = "all"
  }

}

# synthetics
module "wcar_synthetic" {
  source = "../sign-synth"

  synthetics_map = var.synthetics_map

  env       = var.env
  policy_id = newrelic_alert_policy.lcert_wcar_infora_policy.id
  product   = "WCAR"
}