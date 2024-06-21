variable "env" {
  description = "environment"
  type        = string
}

variable "label" {
  description = "label to filter data from Log table"
  type        = string
}

variable "app" {
  description = "apache application"
  type        = string
}

variable "service_name" {
  description = "apache service_name"
  type        = string
}

variable "team" {
  description = "InfoCert Team"
  type        = string
}

variable "vm" {
  description = "virtual machine providing the service"
  type        = string
}