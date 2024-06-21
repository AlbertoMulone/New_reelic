resource "newrelic_one_dashboard" "dashboard_k8s_generic" {
  for_each    = var.create_dashboards ? var.dashboards_k8s : {}
  name        = "${each.value.env} | ${each.value.team} | K8S AWS ${each.value.label}"
  description = null
  permissions = "public_read_write"
  account_id  = 2698411
  
  page {
    name = "${each.value.env} | ${each.value.team} | K8S AWS ${each.value.label} Main page"
    
    widget_billboard {
      title  = "Pod Status: STAMP"
      column = 1
      row    = 1
      height = 2
      width  = 6

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT latest(`podsAvailable`) AS 'Available pods', latest(`podsDesired`) as 'Desired pods', latest(`podsUpdated`) AS 'Updated pods', latest(`podsUnavailable`) AS 'Unavailable pods', latest(`podsMaxUnavailable`) AS 'Max Unavailable pods' FROM K8sDeploymentSample WHERE `clusterName` = '${each.value.cluster}' AND `deploymentName` = '${each.value.deployment1}'"
      }
    }

    widget_billboard {
      title  = "Pod Status: STAMP ADMIN"
      column = 7
      row    = 1
      height = 2
      width  = 6

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT latest(`podsAvailable`) AS 'Available pods', latest(`podsDesired`) as 'Desired pods', latest(`podsUpdated`) AS 'Updated pods', latest(`podsUnavailable`) AS 'Unavailable pods', latest(`podsMaxUnavailable`) AS 'Max Unavailable pods' FROM K8sDeploymentSample WHERE `clusterName` = '${each.value.cluster}' AND `deploymentName` = '${each.value.deployment2}'"
      }
    }

    widget_stacked_bar {
      title  = "Pod Status"
      column = 1
      row    = 3
      height = 3
      width  = 6

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "FROM K8sContainerSample SELECT COUNT(*) WHERE `clusterName` = '${each.value.cluster}' AND `namespaceName` = '${each.value.namespace}' AND `reason` IS NOT NULL FACET `containerName`, `reason` LIMIT MAX TIMESERIES"
      }
    }

    widget_table {
      title  = "K8s Nodes Health"
      column = 7
      row    = 3
      height = 3
      width  = 6

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(`allocatableMemoryUtilization`), average(`allocatableCpuCoresUtilization`) FROM K8sNodeSample WHERE `apmApplicationNames` LIKE '%${each.value.app}%' AND `clusterName` = '${each.value.cluster}' FACET `label.kubernetes.io/hostname` LIMIT MAX"
      }
    }

    widget_line {
      title  = "Avg % CPU usage per Pod"
      column = 1
      row    = 6
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(`cpuCoresUtilization`) AS 'avg CPU usage %' FROM K8sContainerSample WHERE `clusterName` = '${each.value.cluster}' AND `namespace` = '${each.value.namespace}' FACET `podName` TIMESERIES LIMIT MAX"
      }
    }

    widget_line {
      title  = "Avg % RAM usage per Pod"
      column = 5
      row    = 6
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(`memoryWorkingSetUtilization`) AS 'avg RAM usage %' FROM K8sContainerSample WHERE `clusterName` = '${each.value.cluster}' AND `namespace` = '${each.value.namespace}' FACET `podName` TIMESERIES LIMIT MAX"
      }
    }

    widget_line {
      title  = "Avg % FS usage per Pod"
      column = 9
      row    = 6
      height = 3
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(`fsUsedPercent`) AS 'avg FS usage %' FROM K8sContainerSample WHERE `clusterName` = '${each.value.cluster}' AND `namespace` = '${each.value.namespace}' FACET `podName` TIMESERIES LIMIT MAX"
      }
    }

    widget_table {
      title  = "Used vs Requested Cores per Container"
      column = 1
      row    = 9
      height = 2
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(`cpuUsedCores`) AS 'Used Cores', average(`cpuRequestedCores`) AS 'Requested Cores' FROM K8sContainerSample FACET `containerName` WHERE `clusterName` = '${each.value.cluster}' AND `namespace` = '${each.value.namespace}' LIMIT MAX"
      }
    }

    widget_table {
      title  = "Used vs Requested Memory per Container"
      column = 5
      row    = 9
      height = 2
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(`memoryWorkingSetBytes`) AS 'Used Memory', average(`memoryRequestedBytes`) AS 'Requested Memory' FROM K8sContainerSample FACET `containerName` WHERE `clusterName` = '${each.value.cluster}' AND `namespace` = '${each.value.namespace}' LIMIT MAX"
      }
    }

    widget_table {
      title  = "Used vs Available FS per Container"
      column = 9
      row    = 9
      height = 2
      width  = 4

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(`fsUsedBytes`) AS 'Used Bytes', average(`fsAvailableBytes`) AS 'Available Bytes' FROM K8sContainerSample FACET `containerName` WHERE `clusterName` = '${each.value.cluster}' AND `namespace` = '${each.value.namespace}' LIMIT MAX"
      }
    }

    widget_line {
      title  = "Network Activity per Pod"
      column = 1
      row    = 11
      height = 3
      width  = 6

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(`net.rxBytesPerSecond`)/1000 AS 'Received KBps', average(`net.txBytesPerSecond`)/1000 AS 'Transmitted KBps' FROM K8sPodSample FACET `podName` WHERE `clusterName` = '${each.value.cluster}' AND `namespace` = '${each.value.namespace}' TIMESERIES LIMIT MAX"
      }
    }

    widget_table {
      title  = "Network Activity per Pod"
      column = 7
      row    = 11
      height = 3
      width  = 6

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(`net.rxBytesPerSecond`)/1000 AS 'Received KBps', average(`net.txBytesPerSecond`)/1000 AS 'Transmitted KBps', average(`net.errorsPerSecond`) as 'Errors / sec' FROM K8sPodSample FACET `podName` WHERE `clusterName` = '${each.value.cluster}' AND `namespace` = '${each.value.namespace}'"
      }
    }

    widget_table {
      title  = "K8s Events"
      column = 1
      row    = 14
      height = 3
      width  = 12

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT `timestamp`, `event.involvedObject.kind`, `event.involvedObject.name`, `event.message` FROM InfrastructureEvent WHERE `clusterName` = '${each.value.cluster}' AND `event.metadata.namespace` = '${each.value.namespace}' LIMIT MAX"
      }
    } 
  }

  page {
    name = "${each.value.env} | ${each.value.team} | K8S AWS ${each.value.label} Services"
    
    widget_billboard {
      title  = "STAMP Services: Avg Response Time [ms]"
      column = 1
      row    = 1
      height = 3
      width  = 2

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(numeric(`Elapsed`)) AS 'Avg Resp Time' FROM Log WHERE `cluster_name` = '${each.value.cluster}' AND `container_name` = 'stamp' AND `Service` IS NOT NULL FACET `Service`"
      }
    }

    widget_line {
      title  = "STAMP Services: Avg Response Time [ms]"
      column = 3
      row    = 1
      height = 3
      width  = 10

      legend_enabled = false

      nrql_query {
        account_id = 2698411
        query      = "SELECT average(numeric(`Elapsed`)) AS 'Avg Resp Time' FROM Log WHERE cluster_name = '${each.value.cluster}' AND `container_name` = 'stamp' AND `Service` IS NOT NULL FACET `Service` TIMESERIES"
      }
    }
  }
}