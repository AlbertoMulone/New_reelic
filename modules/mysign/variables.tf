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
  description = "mysign service name"
  type        = string
}

variable "enable_nagios" {
  description = "mysign enable nagios checks"
  type        = bool
  default     = false
}

variable "synthetics_map" {
  description = "map of synthetics monitors"
  type = any
  default = {}
}