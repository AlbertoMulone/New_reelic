locals {
  common = yamldecode(file("../common.yaml"))
}

module "hsm-ncipher" {
  source       = "../../../modules/hsm-ncipher"
  env          = local.common.env
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "shared"
  hsms         = ["cahtha6c31.clint.infocert.it"]
}
