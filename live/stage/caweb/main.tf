locals {
  common = yamldecode(file("../common.yaml"))
}

module "caweb" {
  source = "../../../modules/caweb-legacy"

  env          = local.common.env
  network_envs = local.common.network_envs
  enabled      = local.common.enabled
  notification = local.common.notification
  label        = "infocert"
  service_name = "caweb"
  nagios_checks = [
    "load",
    "load_emissione",
    "load_revoca",
    "mem",
    "mem_emissione",
    "mem_revoca",
    "disk",
    "inode_var_opt",
    "procs",
    "tcp_50083_emissione",
    "tcp_50098_revoca",
    "tcp_50328_rrc",
    "tcp_50329_rrc",
    "tcp_51238_rrc",
    # "tcp_8080_jetty",
    # "capf_jetty_exception",
    "capf_server_log",
    "capf_errore_emissione_signacert",
    "capf_errore_emissione_unicert",
    "capf_errore_revoca_unicert",
    "capf_expire_signarao"
  ]
}
