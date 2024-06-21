# requirements
terraform {
  required_version = "= 1.4.6"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "= 3.25.2"
    }
  }
}