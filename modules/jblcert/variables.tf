variable "env" {
  description = "environment name"
  default     = ""
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
  description = "service_name"
  type        = string
}

variable "jblcert_services" {
  description = "jblcert services"
  type        = list(string)
  default     = []
}
