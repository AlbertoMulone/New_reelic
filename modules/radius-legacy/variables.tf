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

variable "service_name" {
  description = "radius service_name"
  type        = string
}

variable "nagios_checks" {
  description = "radius nagios_checks"
  type        = list(string)
}
