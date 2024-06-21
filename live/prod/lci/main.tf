locals {
  common = yamldecode(file("../common.yaml"))
}

# variables
locals {
  complete_appname = "lci_infocert_${local.common.env}"
}

resource "newrelic_alert_policy" "lcert_lci_policy" {
  name = "lcert ${local.common.env} lci infocert policy"
}

# notification
module "notification" {
  source = "../../../modules/notification"
 
  name_prefix  = "lcert ${local.common.env} lci infocert"
  policy_id    = newrelic_alert_policy.lcert_lci_policy.id
  notification = "legalcert_ticket"
}


# duration
resource "newrelic_nrql_alert_condition" "LCI_queue_check" {
  count = 1

  policy_id = newrelic_alert_policy.lcert_lci_policy.id
  
  name               = "lci: abnormal queue length"
  type               = "static"
  baseline_direction = "upper_only"
  enabled            = local.common.enabled

  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120

  violation_time_limit_seconds = 2592000

  nrql {
    query = <<EOF
SELECT latest(checksPending)
FROM SyntheticsPrivateLocationStatus
FACET `name`
EOF
  }

  critical {
    operator              = "above"
    threshold             = 50
    threshold_duration    = 60 * 20
    threshold_occurrences = "all"
  }
}