locals {
  common = yamldecode(file("../common.yaml"))
}

module "certssl" {
  source           = "../../../modules/certssl"
  env              = local.common.env
  enabled          = local.common.enabled
  notification     = "legalcert_ticket"
  domain           = "infocert"
  enable_p12_check = true

  p12_gen_aggr_method     = "cadence"
  p12_gen_aggr_timer      = null
  p12_gen_aggr_window     = 1200
  p12_gen_exp_duration    = 1200
  p12_gen_thresh_duration = 1200
}
