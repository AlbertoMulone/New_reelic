resource "newrelic_one_dashboard" "dashboard_apm" {
  for_each    = var.create_dashboards ? var.dashboards_apm : {}
  name        = "${each.value.env} | ${each.value.team} | APM ${each.value.app}"
  description = null
  permissions = "public_read_write"
  account_id  = 2698411

  page {
    name = "${each.value.env} | ${each.value.team} | APM ${each.value.app} Main page"

    widget_pie {
      title  = "Response type percentage"
      column = 1
      row    = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Transaction WHERE appName = '${each.value.label}' ${each.value.filter_errors} FACET CASES ( WHERE httpResponseCode RLIKE '2.+' as Success, WHERE httpResponseCode RLIKE '3.+' as Redirects, WHERE httpResponseCode RLIKE '4.+' as ClientErrors, WHERE httpResponseCode RLIKE '5.+' as ServerErrors )"
      }
    }

    widget_pie {
      title  = "Traffic distribution"
      column = 5
      row    = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Transaction WHERE appName = '${each.value.label}' FACET host"
      }
    }

    widget_billboard {
      title  = "Responses & Duration (95° Percentile)"
      column = 9
      row    = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) AS 'Responses', percentile(duration,95) AS 'Duration' FROM Transaction WHERE appName = '${each.value.label}'"
      }
    }

    widget_area {
      title  = "Failure rate [%]"
      column = 1
      row    = 4
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT filter(count(apm.service.error.count), WHERE `metricTimesliceName` = 'Errors/all') / filter(count(apm.service.transaction.duration), WHERE `metricName` = 'apm.service.transaction.duration') AS 'Failure Rate: All Errors' FROM Metric WHERE ( appName = '${each.value.label}' ) FACET `host` TIMESERIES 5 minutes SINCE 3 hours ago"
      }
    }

    widget_pie {
      title  = "Request type percentage"
      column = 5
      row    = 4
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(apm.service.transaction.duration) FROM Metric WHERE appName = '${each.value.label}' FACET `transactionName`"
      }
    }

    widget_line {
      title  = "Transactions Average Duration over time"
      column = 9
      row    = 4
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(apm.service.transaction.duration) AS Duration FROM Metric WHERE appName = '${each.value.label}' FACET `transactionName` TIMESERIES 5 minutes" #"SELECT percentile(duration,95) AS Duration FROM Transaction WHERE appName = '${each.value.label}' ${each.value.filter_requests} FACET ${each.value.facet_requests} TIMESERIES 5 minutes"
      }
    }

    widget_line {
      title  = "Response types distribution"
      column = 1
      row    = 7
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Transaction WHERE appName = '${each.value.label}' ${each.value.filter_errors} FACET CASES ( WHERE httpResponseCode RLIKE '2.+' as Success, WHERE httpResponseCode RLIKE '3.+' as Redirects, WHERE httpResponseCode RLIKE '4.+' as ClientErrors, WHERE httpResponseCode RLIKE '5.+' as ServerErrors ) TIMESERIES auto SINCE 3 hour ago"
      }
    }

    widget_area {
      title  = "Successes & Redirects"
      column = 5
      row    = 7
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Transaction WHERE appName = '${each.value.label}' WHERE httpResponseCode LIKE '2%' OR httpResponseCode LIKE '3%' FACET CASES ( WHERE httpResponseCode RLIKE '2.+' as Success, WHERE httpResponseCode RLIKE '3.+' as Redirects ) TIMESERIES 5 minutes SINCE 3 hour ago"
      }
    }

    widget_line {
      title  = "Apdex"
      column = 9
      row    = 7
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT apdex(apm.service.apdex) as 'Apdex' FROM Metric WHERE appName = '${each.value.label}' TIMESERIES 5 minutes"
      }
    }

    widget_table {
      title  = "Transactions"
      column = 1
      row    = 10
      height = 3
      width  = 12

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT host, request.method, ${each.value.facet_requests}, httpResponseCode, duration, apdexPerfZone FROM Transaction WHERE appName = '${each.value.label}' since 3 hours ago limit 200"
      }
    }
  }
}