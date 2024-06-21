resource "newrelic_alert_channel" "legalcert_call_h24" {
  name = "legalcert_call_h24"
  type = "opsgenie"

  config {
    api_key = "13c7d4fe-2856-4b8c-b738-1deefb0b2e80"
    tags    = "legalcert_call_h24"
    region  = "EU"
  }
}

resource "newrelic_alert_channel" "legalcert_call_working_time" {
  name = "legalcert_call_working_time"
  type = "opsgenie"

  config {
    api_key = "13c7d4fe-2856-4b8c-b738-1deefb0b2e80"
    tags    = "legalcert_call_working_time"
    region  = "EU"
  }
}

resource "newrelic_alert_channel" "legalcert_ticket" {
  name = "legalcert_ticket"
  type = "opsgenie"

  config {
    api_key = "13c7d4fe-2856-4b8c-b738-1deefb0b2e80"
    tags    = "legalcert_ticket"
    region  = "EU"
  }
}
