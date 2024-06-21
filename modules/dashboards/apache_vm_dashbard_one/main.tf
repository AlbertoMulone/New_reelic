resource "newrelic_one_dashboard" "dashboard" {
  name = "${var.env} | ${var.team} | Apache ${var.app}"

  page {
    name = "${var.env} | ${var.team} | Apache ${var.app}"

    widget_pie {
      title  = "Response type percentage"
      row    = 1
      column = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Log where tag = '${var.label}' facet cases ( WHERE response RLIKE '2.+' as Success, WHERE response RLIKE '3.+' as Redirects, WHERE response RLIKE '4.+' as ClientErrors, WHERE response RLIKE '5.+' as ServerErrors ) limit 10"
      }
    }

    widget_pie {
      title  = "Traffic distribution"
      row    = 1
      column = 5
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Log where tag = '${var.label}' FACET cases( where filename like '%ip1pvlewsfir001%' as ip1pvlewsfir001, where filename like '%ip1pvlewsfir002%' as ip1pvlewsfir002, where filename like '%ip1pvlewsfir003%' as ip1pvlewsfir003, where filename like '%ip1pvlewsfir004%' as ip1pvlewsfir004 )"
      }
    }

    widget_billboard {
      title  = "Responses"
      row    = 1
      column = 9
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) as responses, sum(numeric(size)/(1048576*1000)) as Gbytes FROM Log where tag = '${var.label}'"
      }
    }

    widget_billboard {
      title  = "Elapsed: 95° Percentile by response type"
      row    = 1
      column = 11
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(numeric(elapsed),95) as Elapsed FROM Log where tag = '${var.label}' SINCE 3 hour ago"
        warning    = 2
        critical   = 3
      }
    }

    widget_pie {
      title  = "Request type percentage"
      row    = 4
      column = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Log where tag = '${var.label}' FACET request"
      }
    }

    widget_area {
      title  = "Errors"
      row    = 4
      column = 5
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Log where tag ='${var.label}' facet cases ( WHERE response RLIKE '4.+' as ClientError, WHERE response RLIKE '5.+' as ServerError) TIMESERIES 5 minutes SINCE 3 hour ago"
      }
    }

    widget_line {
      title  = "Response types distribution"
      row    = 4
      column = 9
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Log where tag = '${var.label}' facet cases ( WHERE response RLIKE '2.+' as Success, WHERE response RLIKE '3.+' as redirect, WHERE response RLIKE '2.+' as ClientError, WHERE response RLIKE '5.+' as ServerError ) TIMESERIES auto SINCE 3 hour ago"
      }
    }

    widget_area {
      title  = "Successes & Redirects"
      row    = 7
      column = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT count(*) FROM Log where tag = '${var.label}' facet cases ( WHERE response RLIKE '2.+' as Success, WHERE response RLIKE '3.+' as redirect ) TIMESERIES 5 minutes SINCE 3 hour ago"
      }
    }

    widget_table {
      title  = "Log entries"
      row    = 7
      column = 5
      height = 3
      width  = 8

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT clientip, size, request, response, elapsed FROM Log WHERE tag = '${var.label}' since 3 hours ago limit 200"
      }
    }

    widget_line {
      title  = "Response Time: 95° Percentile"
      row    = 11
      column = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(numeric(elapsed),95) as Elapsed  FROM Log where tag = '${var.label}'  TIMESERIES  5 minutes SINCE 3 hour ago"
      }
      nrql_query {
        account_id = 2698411
        query      = "SELECT 2 as Critical FROM Log WHERE tag = '${var.label}' TIMESERIES 5 minute"
      }
    }

  }
}