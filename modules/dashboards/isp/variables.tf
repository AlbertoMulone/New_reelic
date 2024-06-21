variable "create_dashboards" {
  description = "boolean controlling the creation of all dashboards"
  type        = bool
  default     = true
}

variable "dashboards_isp_overview" {
  description = "details to create dashboards from isp overview"
  type = map(object({
    env  = string
    team = string
  }))
}