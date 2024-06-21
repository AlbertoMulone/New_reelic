locals {
  common = yamldecode(file("../common.yaml"))
}

module "hsm_ncipher_ca" {
  source       = "../../../modules/hsm-ncipher"
  env          = local.common.env
  enabled      = local.common.enabled
  notification = "legalcert_ticket"
  label        = "ca"
  hsms = [
    "cahnshxcpd01.printpdbc.ca.infocert.it",
    "cahnshxcpd02.printpdbc.ca.infocert.it",
    "cahtha6c03.ca.infocert.it",
    "cahtha6c04.ca.infocert.it",
    "cahtha6c05.ca.infocert.it",
    "cahtha6c06.ca.infocert.it",
  ]
}
