variable "env" {
  description = "environment name"
  type        = string
}

variable "network_envs" {
  description = "infocert network environments"
  type        = list(string)
  default     = []
}

variable "enabled" {
  description = "enable alert conditions"
  type        = bool
  default     = true
}

variable "notification" {
  description = "set notification channel"
  type        = string
}

variable "label" {
  description = "unicert label"
  type        = string
}

variable "service_name" {
  description = "unicert service_name"
  type        = string
}

variable "enable_compliance" {
  description = "unicert enable check compliance"
  type        = bool
  default     = false
}

variable "enable_nagios" {
  description = "unicert legacy enable nagios checks"
  type        = bool
  default     = false
}

variable "location_ca" {
  description = "unicert location ca"
  type        = bool
  default     = false
}

variable "enable_ssl" {
  description = "unicert enable ssl"
  type        = bool
  default     = false
}

variable "verify_ssl" {
  description = "unicert verify ssl"
  type        = bool
  default     = false
}

variable "hosts" {
  description = "unicert hosts data"
  type = map(object({
    host = string
    port = number
  }))
  default = {}
}

variable "handlers" {
  description = "unicert handlers data"
  type        = list(string)
  default     = []
}
