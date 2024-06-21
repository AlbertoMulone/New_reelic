variable "create_dashboards" {
  description = "boolean controlling the creation of all dashboards"
  type        = bool
  default     = true
}

variable "dashboards_apm" {
  description = "details to create dashboards from apm agent data"
  type = map(object({
    env             = string
    label           = string
    app             = string
    service_name    = string
    team            = string
    filter_errors   = string
    filter_requests = string
    facet_requests  = string
  }))
}