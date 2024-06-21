locals {
  common = yamldecode(file("../common.yaml"))
}

module "lcerjob_infocert" {
  source       = "../../../modules/lcer-job"
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
      label             = "LEI"
      tech_serv         = "LCER JOB"
      script_file       = "../../../modules/lcer-job/scripts/nav_JOB_scriptedAPI.tpl"
      private           = true
      private_dc        = true

      period                  = "EVERY_DAY"
      disabled_duration_check = true
      result_window           = 1500
      result_threshold        = 0

      params_map        = {
        url = "http://ip1pvliasblc002.print.infocert.it:8081/api/probe/lei-job/last-execution"
      }
    }
    2 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "NOTIFY DB"
      tech_serv         = "LCER JOB"
      script_file       = "../../../modules/lcer-job/scripts/nav_JOB_scriptedAPI.tpl"
      private           = true
      private_dc        = true

      period                  = "EVERY_DAY"
      disabled_duration_check = true
      result_window           = 1500
      result_threshold        = 0

      params_map        = {
        url = "http://ip1pvliasblc002.print.infocert.it:8081/api/probe/notify-db-job/last-execution"
      }
    }
    3 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "LOG PKBOX"
      tech_serv         = "LCER JOB"
      script_file       = "../../../modules/lcer-job/scripts/nav_JOB_scriptedAPI.tpl"
      private           = true
      private_dc        = true

      period                  = "EVERY_DAY"
      disabled_duration_check = true
      result_window           = 1500
      result_threshold        = 0

      params_map        = {
        url = "http://ip1pvliasblc002.print.infocert.it:8081/api/probe/log-pkbox-job/last-execution"
      }
    }
    4 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "TRISSQ EXPIRED"
      tech_serv         = "LCER JOB"
      script_file       = "../../../modules/lcer-job/scripts/nav_JOB_scriptedAPI.tpl"
      private           = true
      private_dc        = true

      period                  = "EVERY_DAY"
      disabled_duration_check = true
      result_window           = 1500
      result_threshold        = 0

      params_map        = {
        url = "http://ip1pvliasblc002.print.infocert.it:8081/api/probe/trissq-expired-job/last-execution"
      }
    }
    5 = {
      type              = "SCRIPT_API"
      enabled           = local.common.enabled
      url_num           = 1
      label             = "ICSS-TRISSQ migration - BMED"
      tech_serv         = "LCER JOB"
      script_file       = "../../../modules/lcer-job/scripts/nav_JOB_scriptedAPI_noalign.tpl"
      private           = true
      private_dc        = true

      period                  = "EVERY_HOUR"
      disabled_duration_check = true
      result_window           = 1500
      result_threshold        = 0

      params_map        = {
        url = "http://ip1pvliasblc002.print.infocert.it:8081/api/probe/icss-to-trissq-migration-job/last-execution"
      }
    }
    # 6 = {
    #   type              = "SCRIPT_API"
    #   enabled           = false // local.common.enabled
    #   url_num           = 1
    #   label             = "ICSS-TRISSQ migration - MPS"
    #   tech_serv         = "LCER JOB"
    #   script_file       = "../../../modules/lcer-job/scripts/nav_JOB_scriptedAPI_noalign.tpl"
    #   private           = true
    #   private_dc        = true

    #   period                  = "EVERY_HOUR"
    #   disabled_duration_check = true
    #   result_window           = 1500
    #   result_threshold        = 0

    #   params_map        = {
    #     url = "http://ip1pvliasblc002.print.infocert.it:8081/api/probe/icss-to-trissq-migration-second-job/last-execution"
    #   }
    # }
    # 7 = {
    #   type              = "SCRIPT_API"
    #   enabled           = false // local.common.enabled
    #   url_num           = 1
    #   label             = "ICSS-TRISSQ migration - WIDIBA"
    #   tech_serv         = "LCER JOB"
    #   script_file       = "../../../modules/lcer-job/scripts/nav_JOB_scriptedAPI_noalign.tpl"
    #   private           = true
    #   private_dc        = true

    #   period                  = "EVERY_HOUR"
    #   disabled_duration_check = true
    #   result_window           = 1500
    #   result_threshold        = 0

    #   params_map        = {
    #     url = "http://ip1pvliasblc002.print.infocert.it:8081/api/probe/icss-to-trissq-migration-third-job/last-execution"
    #   }
    # }
  }
}
