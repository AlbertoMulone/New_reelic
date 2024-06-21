# policy
resource "newrelic_alert_policy" "pub_lcert_wormhole_policy" {
  name = "PUB | lcert ${var.env} wormhole policy"
}

# alert
module "public-synthetics" {
  source           = "../public-synthetics"
  alert_policy_id  = newrelic_alert_policy.pub_lcert_wormhole_policy.id
  enabled          = var.enabled
  nrql_checks_info = var.nrql_checks_info
  env              = var.env

}