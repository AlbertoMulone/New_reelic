locals {
  common = yamldecode(file("../common.yaml"))
}

module "pulsar_infocert" {
  source       = "../../../modules/pulsar"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"

  synthetics_map = {
    1 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "Bind"
      tech_serv         = "ST Registration Authority 2"
      script_file       = "../../../modules/pulsar/scripts/PULSAR_Bind.tpl"
      private           = true
      private_dc        = true

      duration_threshold = 5000

      params_map        = {
        url = "https://pulsarcl.eu-west-1.claws.infocert.it/cl_regaut2/bind"
      }
    }
  }
}
