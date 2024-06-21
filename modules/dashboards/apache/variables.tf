variable "create_dashboards" {
  description = "boolean controlling the creation of all dashboards"
  type        = bool
  default     = true
}

variable "dashboards_apache" { #ip1pvlewsfir
  description = "details to create dashboards for Apache VH"
  type = map(object({
    env          = string
    label        = string
    app          = string
    service_name = string
    team         = string
    facet_filter = string
  }))
}
/*
variable "dashboards_ip1pvlewscer" {
  description = "details to create dashboards for Apache VH running on ip1pvlewscer###"
  type = map(object({
    env          = string
    label        = string
    app          = string
    service_name = string
    team         = string
  }))
}

variable "dashboards_ip1pvlewsisp" {
  description = "details to create dashboards for Apache VH running on ip1pvlewsisp###"
  type = map(object({
    env          = string
    label        = string
    app          = string
    service_name = string
    team         = string
  }))
}

variable "dashboards_ip1pvlewscer_vleweb" {
  description = "details to create dashboards for Apache VH running on ip1pvlewscer### and vleweb##SSL"
  type = map(object({
    env          = string
    label        = string
    app          = string
    service_name = string
    team         = string
  }))
}

variable "dashboards_ip1pvliwsfir" {
  description = "details to create dashboards for Apache VH running on ip1pvliwsfir###"
  type = map(object({
    env          = string
    label        = string
    app          = string
    service_name = string
    team         = string
  }))
}

variable "dashboards_ip1pvliwscer" {
  description = "details to create dashboards for Apache VH running on ip1pvliwscer###"
  type = map(object({
    env          = string
    label        = string
    app          = string
    service_name = string
    team         = string
  }))
}

variable "dashboards_ip1pvliwsisp" {
  description = "details to create dashboards for Apache VH running on ip1pvliwsisp###"
  type = map(object({
    env          = string
    label        = string
    app          = string
    service_name = string
    team         = string
  }))
}
*/