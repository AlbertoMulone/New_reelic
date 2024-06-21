variable "create_dashboards" {
  description = "boolean controlling the creation of all dashboards"
  type        = bool
  default     = true
}

variable "dashboards_k8s" {
  description = "details to create dashboards dedicate to k8s service"
  type = map(object({
    env             = string
    label           = string
    app             = string
    team            = string
    cluster         = string
    deployment      = string
    namespace       = string
  }))
}