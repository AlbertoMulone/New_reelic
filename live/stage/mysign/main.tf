locals {
  common = yamldecode(file("../common.yaml"))
}

# policy
resource "newrelic_alert_policy" "lcert_mysign_policy" {
  name = "lcert ${local.common.env} mysign policy"
}

# notification
module "notification" {
  source = "../../../modules/notification"
 
  name_prefix  = "lcert ${local.common.env} mysign"
  policy_id    = newrelic_alert_policy.lcert_mysign_policy.id
  notification = local.common.notification
}

# synthetics
module "mysign_synthetic" {
  source = "../../../modules/sign-synth"

  synthetics_map = {
    1 = {
      type             = "SCRIPT_BROWSER"
      enabled          = local.common.enabled
      url_num          = 1
      label            = "Login MySign CL"
      tech_serv        = "ST Firma Remota Intesi"
      script_file      = "../../../modules/mysign/scripts/nav_MYSIGN_login_new.tpl"
      duration_timeout = 15000

      params_map        = {
        url  = "https://mysigncl.infocert.it/#/login"
        user = "MYSIGN_LOGIN_USER_CLD"
        pass = "MYSIGN_LOGIN_PASS_CLD"
      }
    }
  }

  env       = local.common.env
  policy_id = newrelic_alert_policy.lcert_mysign_policy.id
  product   = "MYSIGN"
}