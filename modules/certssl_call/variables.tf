variable "env" {
  description = "environment name"
  type        = string
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

variable "domain" {
  description = "domain"
  type        = string
}

variable "enable_p12_call_check" {
  description = "enable p12 certificates check w/opsgenie call"
  type        = bool
  default     = false
}

variable "p12_exp_filter_mTLS" {
  description = "p12 expire error: filter for target services"
  type        = string
  default     = ""
}

variable "p12_exp_filter_SSL" {
  description = "p12 expire error: filter for target services"
  type        = string
  default     = ""
}
