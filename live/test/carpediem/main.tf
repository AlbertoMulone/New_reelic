locals {
  common = yamldecode(file("../common.yaml"))
}

module "carpediem_infocert" {
  source = "../../../modules/carpediem"

  env           = local.common.env
  network_envs  = local.common.network_envs
  enabled       = true
  notification  = local.common.notification
  label         = "infocert"
  service_name  = "carpeice"
}

# temp
module "carpediem_postgres" {
  source = "../../../modules/carpediem"

  env          = "svil"
  network_envs = ["svint"]
  enabled      = true
  notification = local.common.notification
  label        = "postgres"
  service_name = "carpepostgres"
}
