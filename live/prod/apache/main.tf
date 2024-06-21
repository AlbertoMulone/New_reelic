locals {
  common = yamldecode(file("../common.yaml"))
}

module "apache" {
  source = "../../../modules/apache"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "apache infocert"
  service_name = "apache"
}

module "apache_ifc" {
  source = "../../../modules/apache"

  env          = local.common.env
  network_envs = local.common.network_envs_ifc
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "apache infocamere"
  service_name = "apacheifc"
}
