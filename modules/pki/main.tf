# policy
resource "newrelic_alert_policy" "lcert_pki_policy" {
  name = "lcert ${var.env} pki policy"
}

# notification
module "notification" {
  source = "../notification"
 
  name_prefix  = "lcert ${var.env} pki"
  policy_id    = newrelic_alert_policy.lcert_pki_policy.id
  notification = var.notification
}

# synthetic
module "synthetic" {
  for_each = var.urls

  source = "../synthetic"

  policy_id = newrelic_alert_policy.lcert_pki_policy.id
  
  env    = var.env
  name   = "lcert ${var.env} pki url ${each.key}"
  label  = each.key
  type   = "SIMPLE"
  period = "EVERY_5_MINUTES"
  url    = each.value

  tags = {
    brand             = "LEGALCERT"
    team              = "LegalCert"
    environment       = var.env
    technical_service = "ST PKI Shared"
  }

}

# # synthetic script example
# module "test" {

#   source = "../synthetic"

#   policy_id = newrelic_alert_policy.lcert_pki_policy.id
  
#   env    = var.env
#   name   = "lcert ${var.env} TEST url 1"
#   label  = "TEST"
#   type   = "SCRIPT_API"
#   period = "EVERY_5_MINUTES"

#   script_file = "${path.module}/scripts/PULSAR_Bind.tftpl.js"
#   params_map = {
#     url = "https://pulsarcl.eu-west-1.claws.infocert.it/cl_regaut2/bind"
#   }

#   private = true
#   disabled_result_check = true
#   disabled_duration_check = true

#   tags = {
#     brand             = "LEGALCERT"
#     team              = "LegalCert"
#     environment       = var.env
#     technical_service = "ST PKI Shared"
#   }

# }
