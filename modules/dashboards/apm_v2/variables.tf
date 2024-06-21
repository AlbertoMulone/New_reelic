variable "create_dashboards" {
  description = "boolean controlling the creation of all dashboards"
  type        = bool
  default     = true
}

variable "dashboards_apm_v2" {
  description = "details to create dashboards from apm agent data"
  type = map(object({
    env             = string
    label           = string
    app             = string
    service_name    = string
    team            = string
    filter_errors   = string
  }))
}