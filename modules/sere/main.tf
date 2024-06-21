# policy
resource "newrelic_alert_policy" "lcert_sere_policy" {
  name = "lcert ${var.env} sere policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} sere"
  policy_id    = newrelic_alert_policy.lcert_sere_policy.id
  notification = var.notification
}

# synthetic
module "sere_welcome" {
  source = "../synthetic"

  policy_id = newrelic_alert_policy.lcert_sere_policy.id
  
  env    = var.env
  name   = "PUB | SERE | ${upper(var.env)} | Welcome - URL 1"
  label  = "welcome"
  type   = "SIMPLE"
  period = "EVERY_5_MINUTES"
  url    = var.url

  validation_string = "WELCOME"

  private = true

  tags = {
    brand             = "LEGALCERT"
    team              = "LegalCert"
    environment       = var.env
    technical_service = "ST LISPA"
  }

}
