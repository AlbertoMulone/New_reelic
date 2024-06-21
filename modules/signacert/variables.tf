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
  description = "signacert label"
  type        = string
}

variable "service_name" {
  description = "signacert service_name"
  type        = string
}

variable "enable_compliance" {
  description = "signacert enable check compliance"
  type        = bool
  default     = false
}

variable "enable_nagios" {
  description = "signacert legacy enable nagios checks"
  type        = bool
  default     = false
}

variable "ntp_type" {
  description = "signacert ntp type"
  type        = string
  default     = "ntpd"
}