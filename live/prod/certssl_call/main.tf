locals {
  common = yamldecode(file("../common.yaml"))
}

module "certssl_call" {
  source           = "../../../modules/certssl_call"
  env              = local.common.env
  enabled          = local.common.enabled
  notification     = local.common.notification
  domain           = "infocert"
  enable_p12_call_check = true

}

module "certssl_call_ifc" {
  source       = "../../../modules/certssl_call"
  env          = local.common.env
  enabled      = local.common.enabled
  notification = local.common.notification
  domain       = "infocamere"
}
