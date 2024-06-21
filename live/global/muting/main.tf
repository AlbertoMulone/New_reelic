
resource "newrelic_alert_muting_rule" "lcert_muting_rule" {
  name        = "lcert global muting rule"
  enabled     = true
  description = "muting: disk, no data, compliance, expire, max credential"

  condition {
    conditions {
      attribute = "conditionName"
      operator  = "CONTAINS"
      values    = ["disk"]
    }
    conditions {
      attribute = "conditionName"
      operator  = "CONTAINS"
      values    = ["no data"]
    }
    conditions {
      attribute = "conditionName"
      operator  = "CONTAINS"
      values    = ["compliance"]
    }
    conditions {
      attribute = "conditionName"
      operator  = "CONTAINS"
      values    = ["expire"]
    }
    conditions {
      attribute = "conditionName"
      operator  = "CONTAINS"
      values    = ["max credential"]
    }
    operator = "OR"
  }

  schedule {
    start_time = "2022-04-15T00:00:00"
    end_time   = "2022-04-15T23:59:00"
    time_zone  = "UTC"
    repeat     = "DAILY"
  }
}
