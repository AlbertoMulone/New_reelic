locals {
  common = yamldecode(file("../common.yaml"))
}

module "hsm-ncipher" {
  source       = "../../../modules/hsm-ncipher"
  env          = local.common.env
  enabled      = true
  notification = local.common.notification
  label        = "shared"
  hsms         = ["cahtha5c21.tsint.infocert.it"]
}
