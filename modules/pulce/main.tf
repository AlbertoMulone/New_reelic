# policy
resource "newrelic_alert_policy" "lcert_pulce_policy" {
  name = "lcert ${var.env} pulce policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} pulce"
  policy_id    = newrelic_alert_policy.lcert_pulce_policy.id
  notification = var.notification
}

# synthetic
module "pulce_welcome" {
  source = "../synthetic"

  policy_id = newrelic_alert_policy.lcert_pulce_policy.id
  
  env    = var.env
  name   = "PUB | PULCE | ${upper(var.env)} | Welcome - URL 1"
  label  = "welcome"
  type   = "SCRIPT_API"
  period = "EVERY_10_MINUTES"

  script_file = "${path.module}/scripts/PULCE_welcome.tftpl.js"
  params_map = {
    url = var.url
  }

  private = true

  tags = {
    brand             = "LEGALCERT"
    team              = "LegalCert"
    environment       = var.env
    technical_service = "ST LISPA"
  }

}
