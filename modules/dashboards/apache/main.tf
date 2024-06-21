resource "newrelic_one_dashboard" "dashboard_apache" {
  for_each    = var.create_dashboards ? var.dashboards_apache : {}
  name        = "${each.value.env} | ${each.value.team} | Apache ${each.value.app}"
  description = null
  permissions = "public_read_write"
  account_id  = 2698411

  page {
    name = "${each.value.env} | ${each.value.team} | Apache ${each.value.app} Main page"

    widget_pie {
      title  = "Response type percentage"
      column = 1
      row    = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Log where tag = '${each.value.label}' facet cases ( WHERE response RLIKE '2.+' as Success, WHERE response RLIKE '3.+' as Redirects, WHERE response RLIKE '4.+' as ClientErrors, WHERE response RLIKE '5.+' as ServerErrors ) limit 10"
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
        query      = "SELECT count(*) FROM Log where tag = '${each.value.label}' ${each.value.facet_filter}"
      }
    }

    widget_billboard {
      title  = "Responses"
      column = 9
      row    = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) as responses, sum(numeric(size)/(1048576*1000)) as Gbytes FROM Log where tag = '${each.value.label}'"
      }
    }

    widget_area {
      title  = "Errors"
      column = 1
      row    = 4
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Log where tag ='${each.value.label}' facet cases ( WHERE response RLIKE '4.+' as ClientError, WHERE response RLIKE '5.+' as ServerError) TIMESERIES 5 minutes SINCE 3 hour ago"
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
        query      = "SELECT count(*) FROM Log where tag = '${each.value.label}' FACET request"
      }
    }

    widget_billboard {
      title  = "Elapsed: 95° Percentile by response type"
      column = 9
      row    = 4
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(numeric(elapsed),95) as Elapsed FROM Log where tag = '${each.value.label}' SINCE 3 hour ago"
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
        query      = "SELECT count(*) FROM Log where tag = '${each.value.label}' facet cases ( WHERE response RLIKE '2.+' as Success, WHERE response RLIKE '3.+' as Redirect, WHERE response RLIKE '2.+' as ClientError, WHERE response RLIKE '5.+' as ServerError ) TIMESERIES auto SINCE 3 hour ago"
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
        query      = "SELECT count(*) FROM Log where tag = '${each.value.label}' facet cases ( WHERE response RLIKE '2.+' as Success, WHERE response RLIKE '3.+' as Redirect ) TIMESERIES 5 minutes SINCE 3 hour ago"
      }
    }

    widget_line {
      title  = "Response Time: 95° Percentile"
      column = 9
      row    = 7
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(numeric(elapsed),95) as Elapsed  FROM Log where tag = '${each.value.label}'  TIMESERIES  5 minutes SINCE 3 hour ago"
      }
    }

    widget_table {
      title  = "Log Entries"
      column = 1
      row    = 10
      height = 3
      width  = 12

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT clientip, size, request, response, elapsed FROM Log WHERE tag = '${each.value.label}' since 3 hours ago limit 200"
      }
    }
  }
}
