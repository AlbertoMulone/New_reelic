# policy
resource "newrelic_alert_policy" "lcert_ecer_policy" {
  name = "lcert ${var.env} ecer policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} ecer"
  policy_id    = newrelic_alert_policy.lcert_ecer_policy.id
  notification = var.notification
}

# synthetic
module "ecer_webservice" {
  source = "../synthetic"

  policy_id = newrelic_alert_policy.lcert_ecer_policy.id
  
  env    = var.env
  name   = "PUB | ECER | ${upper(var.env)} | Welcome Service - URL 1"
  label  = "ECER Welcome Service - URL 1"
  type   = "SIMPLE"
  period = "EVERY_5_MINUTES"
  url    = var.ecer_webservice

  validation_string = "Hello World!"

  tags = {
    brand             = "LEGALCERT"
    team              = "LegalCert"
    environment       = var.env
    technical_service = "ST Generazione Altri Certificati"
  }

}
