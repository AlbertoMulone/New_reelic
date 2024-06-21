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
  description = "caweb label"
  type        = string
}

variable "service_name" {
  description = "caweb service_name"
  type        = string
}

variable "enable_nagios" {
  description = "signacert legacy enable nagios checks"
  type        = bool
  default     = false
}

variable "capf_proc_num" {
  description = "capf process max number"
  type        = number
  default     = 3
}

variable "enable_high_cpu_usage" {
  description = "enable high cpu usage"
  type        = bool
  default     = true
}
