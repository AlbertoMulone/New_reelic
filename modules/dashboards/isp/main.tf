resource "newrelic_one_dashboard" "dashboard_isp_overview" {
  for_each    = var.create_dashboards ? var.dashboards_isp_overview : {}
  name        = "${each.value.env} | ${each.value.team} | ISP Overview"
  description = null
  permissions = "public_read_write"
  account_id  = 2698411

  page {
    name = "${each.value.env} | ${each.value.team} | ISP Overview Main page"

    widget_line {
      title  = "Servizi di Emissione | Certificate"
      column = 1
      row    = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT round(count(*)) as 'emit' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/certificate (POST)' TIMESERIES AUTO"
      }
    }

    widget_billboard {
      title  = "Servizi di Emissione Percentile | Certificate"
      column = 5
      row    = 1
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(duration, 96) as 'percentile' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/certificate (POST)'"
      }

      warning  = 3
      critical = 3.5
    }

    widget_line {
      title  = "Servizi di Emissione | Certificate/query"
      column = 7
      row    = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT round(count(*)) as 'query' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/certificate/query (GET)'  TIMESERIES AUTO"
      }
    }

    widget_billboard {
      title  = "Servizi di Emissione Percentile | Certificate/query"
      column = 12
      row    = 1
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(duration, 96) as 'percentile' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/certificate/query (GET)'"
      }

      warning  = 1.5
      critical = 2
    }

    widget_line {
      title  = "Servizi di registrazione | IUT"
      column = 1
      row    = 4
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT round(count(*)) as 'iut' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/iut (POST)' TIMESERIES AUTO"
      }
    }

    widget_billboard {
      title  = "Servizi di registrazione Percentile | IUT"
      column = 5
      row    = 4
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(duration, 96) as 'percentile' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/iut (POST)'"
      }

      warning  = 2
      critical = 2.5
    }

    widget_bullet {
      title  = "CRL ERROR IntesaSanpaololdenTrust AWS"
      column = 7
      row    = 4
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT COUNT(*) FROM CRLSample WHERE `FILE` = 'IntesaSanpaololdenTrust_AWS.input%' AND (`CRL_STATUS` != 'OK' AND `CRL_STATUS` != 'ER: CRL corrotta') OR `CA_STATUS` != 'OK'"
      }

      limit = 56
    }

    widget_bullet {
      title  = "CRL ERROR IntesaSanpaololdenTrust"
      column = 12
      row    = 4
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT COUNT(*) FROM CRLSample WHERE `FILE` = 'IntesaSanpaololdenTrust.input' AND (`CRL_STATUS` != 'OK' AND `CRL_STATUS` != 'ER: CRL corrotta') OR `CA_STATUS` != 'OK'"
      }

      limit = 56
    }

    widget_line {
      title  = "ISP | OCSP"
      column = 1
      row    = 7
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT round(count(*)) as 'ocsp' from Transaction where appName='ogre2isp_praws' TIMESERIES AUTO"
      }
    }

    widget_billboard {
      title  = "ISP | OCSP"
      column = 5
      row    = 7
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT round(percentile(duration, 96)*1000)/1000 as 'percentile 96%' from Transaction where appName='ogre2isp_praws' and transactionType = 'Web' and name in ('WebTransaction/RestWebService/{request : .+} (GET)', 'WebTransaction/RestWebService/ (POST)')"
      }

      warning  = 1.5
      critical = 2
    }

    widget_bullet {
      title  = "CRL ERROR IntesaSanpaololdenFQ AWS"
      column = 7
      row    = 7
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT COUNT(*) FROM CRLSample WHERE `FILE` = 'IntesaSanpaoloFQ_AWS.input' AND (`CRL_STATUS` != 'OK' AND `CRL_STATUS` != 'ER: CRL corrotta') OR `CA_STATUS` != 'OK'"
      }

      limit = 56
    }

    widget_bullet {
      title  = "CRL ERROR IntesaSanpaololdenFQ"
      column = 12
      row    = 7
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT COUNT(*) FROM CRLSample WHERE `FILE` = 'IntesaSanpaoloFQ.input' AND (`CRL_STATUS` != 'OK' AND `CRL_STATUS` != 'ER: CRL corrotta') OR `CA_STATUS` != 'OK'"
      }

      limit = 56
    }

    widget_billboard {
      title  = "Marcatura"
      column = 1
      row    = 10
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentage(count(*),WHERE STATUS ='OK') as 'availability' FROM STAMP_Sample WHERE environment = 'prod'"
      }

      warning  = 0.95
      critical = 0.9
    }
  }

  page {
    name = "${each.value.env} | ${each.value.team} | ISP Detail"

    widget_line {
      title  = "Servizi di Emissione | Certificate | ERROR RATE"
      column = 1
      row    = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentage(count(*), WHERE error is true) AS 'Error rate' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/certificate (POST)' TIMESERIES AUTO"
      }
    }

    widget_line {
      title  = "Servizi di Emissione | Certificate | Response time"
      column = 5
      row    = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(duration * 1000, 90) AS 'Response time' FROM Transaction WHERE ( appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/certificate (POST)') TIMESERIES LIMIT 10 SINCE 1800 seconds ago EXTRAPOLATE"
      }
    }

    widget_line {
      title  = "Servizi di Emissione | Certificate | Throughput"
      column = 9
      row    = 1
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT rate(count(*), 1 minute) AS 'Requests per minute' FROM Transaction WHERE appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/certificate (POST)' TIMESERIES FACET `appId` LIMIT 10 SINCE 1800 seconds ago EXTRAPOLATE"
      }
    }

    widget_line {
      title  = "ISP | OCSP"
      column = 1
      row    = 4
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT round(count(*)) as 'ocsp' from Transaction where appName='ogre2isp_praws' TIMESERIES AUTO"
      }
    }

    widget_billboard {
      title  = "Servizi di Emissione Percentile | Certificate"
      column = 5
      row    = 4
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(duration, 96) as 'percentile' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/certificate (POST)'"
      }

      warning  = 3
      critical = 3.5
    }

    widget_line {
      title  = "Servizi di registrazione| IUT"
      column = 9
      row    = 4
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT round(count(*)) as 'iut' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/iut (POST)' TIMESERIES AUTO"
      }
    }

    widget_billboard {
      title  = "Marcatura"
      column = 1
      row    = 7
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentage(count(*),WHERE STATUS ='OK') as 'availability' FROM STAMP_Sample WHERE environment = 'prod'"
      }

      warning  = 0.95
      critical = 0.9
    }

    widget_billboard {
      title  = "Servizi di registrazione Percentile | IUT"
      column = 5
      row    = 7
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(duration, 96) as 'percentile' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/iut (POST)'"
      }

      warning  = 2
      critical = 2.5
    }

    widget_line {
      title  = "Servizi di Emissione | Certificate/query"
      column = 7
      row    = 7
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT round(count(*)) as 'query' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/certificate/query (GET)'  TIMESERIES AUTO"
      }
    }

    widget_billboard {
      title  = "Servizi di Emissione Percentile | Certificate/query"
      column = 11
      row    = 7
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT percentile(duration, 96) as 'percentile' from Transaction where appName='wormhole_prod' and name='WebTransaction/RestWebService/lcrs-service/certificate/query (GET)'"
      }

      warning  = 1.5
      critical = 2
    }

    widget_billboard {
      title  = "ISP | OCSP"
      column = 1
      row    = 10
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT round(percentile(duration, 96)*1000)/1000 as 'percentile 96%' from Transaction where appName='ogre2isp_praws' and transactionType = 'Web' and name in ('WebTransaction/RestWebService/{request : .+} (GET)', 'WebTransaction/RestWebService/ (POST)')"
      }

      warning  = 1.5
      critical = 2
    }

    widget_bullet {
      title  = "CRL ERROR IntesaSanpaololdenTrust AWS"
      column = 5
      row    = 10
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT COUNT(*) FROM CRLSample WHERE `FILE` = 'IntesaSanpaololdenTrust_AWS.input%' AND (`CRL_STATUS` != 'OK' AND `CRL_STATUS` != 'ER: CRL corrotta') OR `CA_STATUS` != 'OK'"
      }

      limit = 56
    }

    widget_bullet {
      title  = "CRL ERROR IntesaSanpaololdenTrust"
      column = 9
      row    = 10
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT COUNT(*) FROM CRLSample WHERE `FILE` = 'IntesaSanpaololdenTrust.input' AND (`CRL_STATUS` != 'OK' AND `CRL_STATUS` != 'ER: CRL corrotta') OR `CA_STATUS` != 'OK'"
      }

      limit = 56
    }

    widget_bullet {
      title  = "CRL ERROR IntesaSanpaololdenFQ AWS"
      column = 1
      row    = 13
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT COUNT(*) FROM CRLSample WHERE `FILE` = 'IntesaSanpaoloFQ_AWS.input' AND (`CRL_STATUS` != 'OK' AND `CRL_STATUS` != 'ER: CRL corrotta') OR `CA_STATUS` != 'OK'"
      }

      limit = 56
    }

    widget_bullet {
      title  = "CRL ERROR IntesaSanpaololdenFQ"
      column = 5
      row    = 13
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT COUNT(*) FROM CRLSample WHERE `FILE` = 'IntesaSanpaoloFQ.input' AND (`CRL_STATUS` != 'OK' AND `CRL_STATUS` != 'ER: CRL corrotta') OR `CA_STATUS` != 'OK'"
      }

      limit = 56
    }
  }
}