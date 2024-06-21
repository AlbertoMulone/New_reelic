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
  description = "pkbox label"
  type        = string
}

variable "service_name" {
  description = "pkbox service_name"
  type        = string
}

variable "pkbox_command_line" {
  description = "pkbox commandLine"
  type        = string
  default     = "/usr/PkBox8/java/default/bin/java"
}

variable "enable_nagios" {
  description = "pkbox enable nagios checks"
  type        = bool
  default     = false
}

variable "enable_max_credentials" {
  description = "pkbox enable max credentials checks"
  type        = bool
  default     = false
}

variable "max_credentials_limit" {
  description = "pkbox max credentials error limit"
  type        = number
  default     = 90
}

variable "enable_ssl" {
  description = "pkbox enable ssl"
  type        = bool
  default     = false
}

variable "verify_ssl" {
  description = "pkbox verify ssl"
  type        = bool
  default     = true
}

variable "basic_auth" {
  description = "pkbox enable basic auth"
  type        = bool
  default     = false
}

variable "enable_balancer" {
  description = "pkbox enable balancer check"
  type        = bool
  default     = false
}

variable "balancer" {
  description = "pkbox balancer data"
  type = object({
    host = string
    port = number
  })
  default = {
    host = ""
    port = 0
  }
}

variable "hosts" {
  description = "pkbox hosts data"
  type = map(object({
    host = string
    port = number
  }))
}

variable "handlers" {
  description = "pkbox handlers data"
  type        = list(string)
}

variable "enable_ntpd_check" {
  description = "pkbox enable ntpd service check"
  type        = bool
  default     = false
}

variable "high_cpu_usage_percent" {
  description = "high cpu usage percent error"
  type        = number
  default     = 90
}