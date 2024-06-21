locals {
  common = yamldecode(file("../common.yaml"))
}

module "fcertice" {
  source       = "../../../modules/fbcert"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  basename     = "fcert"
  label        = "infocert"
  instances    = ["emis", "fire", "zucmarca", "marca", "regs", "regsext", "restcert", "ecerfe"]
  service_name = "fcertice"
}

module "bcertice" {
  source       = "../../../modules/fbcert"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  basename     = "bcert"
  label        = "infocert"
  instances    = ["cabeejb", "fireejb", "firmaejb", "regsejb", "restcertejb", "ncfrejb", "ecerbe"]
  service_name = "bcertice"
  batch_vm     = true
}

module "fcertisp" {
  source       = "../../../modules/fbcert"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  basename     = "fcert"
  label        = "isp"
  instances    = ["emisisp", "regsextisp", "regsisp", "restcertisp"]
  service_name = "fcertisp"
}

module "bcertisp" {
  source       = "../../../modules/fbcert"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  basename     = "bcert"
  label        = "isp"
  instances    = ["cabeejbisp", "fireejbisp", "regsejbisp", "restcertejbisp", "ecerbeisp"]
  service_name = "bcertisp"
}

module "fcertcns" {
  source       = "../../../modules/fbcert"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  #notification = local.common.notification
  notification = "legalcert_ticket"
  basename     = "fcert"
  label        = "cns"
  instances    = ["emiscns", "restcertcns"]
  service_name = "fcertcns"
}

module "bcertcns" {
  source       = "../../../modules/fbcert"
  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  #notification = local.common.notification
  notification = "legalcert_ticket"
  basename     = "bcert"
  label        = "cns"
  instances    = ["cabeejbcns", "fireejbcns", "restcertejbcns"]
  service_name = "bcertcns"
}
