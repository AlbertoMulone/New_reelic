locals {
  common = yamldecode(file("../common.yaml"))
}

module "newrelic_synthetics" {
  source = "../../../modules/newrelic-synthetics"

  env          = "mgmt"
  network_envs = ["mgmt"]
  enabled      = local.common.enabled
  notification = "legalcert_ticket"
  service_name = "lcert_nr_minion"
  minion_name  = "lcert-nr-synthetics-mgmt-01"
}

module "newrelic_synthetics_ca" {
  source = "../../../modules/newrelic-synthetics"

  env          = "mgmt ca"
  network_envs = ["mgmt.ca"]
  enabled      = local.common.enabled
  notification = "legalcert_ticket"
  service_name = "lcert_nr_minion"
  minion_name  = "lcert-nr-synthetics-mgmt-ca-01"
}
