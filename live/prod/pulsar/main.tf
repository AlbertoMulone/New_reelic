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
        url = "https://pulsarpr.eu-west-1.praws.infocert.it/pr_regaut2/bind"
      }
    }
    2 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "Verify"
      tech_serv         = "ST Registration Authority 2"
      script_file       = "../../../modules/pulsar/scripts/PULSAR_Verify.tpl"
      private           = true
      private_dc        = true

      duration_threshold = 5000

      params_map        = {
        url = "https://pulsarpr.eu-west-1.praws.infocert.it/pr_regaut2/verify"
      }
    }
    3 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "Resend"
      tech_serv         = "ST Registration Authority 2"
      script_file       = "../../../modules/pulsar/scripts/PULSAR_Resend.tpl"
      private           = true
      private_dc        = true

      duration_threshold = 5000

      params_map        = {
        url = "https://pulsarpr.eu-west-1.praws.infocert.it/pr_regaut2/resend"
      }
    }
  }
}
