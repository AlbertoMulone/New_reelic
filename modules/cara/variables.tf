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

variable "enable_checks" {
  description = "global var to enable checks"
  type        = bool
  default     = false
}

variable "db_monitor_info" {
  description = "db queries results"
  type = map(object({
    product      = string
    service_name = string
    thresh_crt   = number
    thresh_wrn   = number
  }))
}