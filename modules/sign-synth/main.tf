module "sign-synth" {
  source = "../synthetic"

  for_each  = var.synthetics_map

  env       = var.env
  policy_id = var.policy_id
  enabled   = each.value.enabled
  name      = "PUB | ${upper(try(each.value.product, var.product))} | ${upper(var.env)} | ${each.value.label} - URL ${each.value.url_num}"
  label     = each.value.label
  period    = try(each.value.period, var.env == "prod" ? "EVERY_5_MINUTES" : "EVERY_10_MINUTES")
  type      = each.value.type

  private     = try(each.value.private, false)
  private_dc  = try(each.value.private_dc, false)
  private_dc_jobmanager = try(each.value.private_dc_jobmanager, false)

  url               = try(each.value.url, null)
  validation_string = try(each.value.validation_string, null)
  verify_ssl        = try(each.value.verify_ssl, true)
  script_file       = try(each.value.script_file, null)
  script_language   = try(each.value.script_language, null)

  runtime_type      = try(each.value.runtime_type, null)
  params_map        = try(each.value.params_map, null)

  disabled_result_check   = try(each.value.disabled_result_check, false)
  result_window           = try(each.value.result_window, null)
  result_threshold        = try(each.value.result_threshold, null)
  disabled_duration_check = try(each.value.disabled_duration_check, false)
  duration_window         = try(each.value.duration_window, null)
  duration_threshold      = try(each.value.duration_threshold, null)
  duration_timeout        = try(each.value.duration_timeout, null)

  tags = {
    brand             = "LEGALCERT"
    team              = "LegalCert"
    environment       = var.env
    technical_service = each.value.tech_serv
  }
}