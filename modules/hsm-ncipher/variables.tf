variable "env" {
  description = "environment name"
  type        = string
}

variable "label" {
  description = "hsm label"
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

variable "hsms" {
  description = "set list hsm names"
  type        = list(string)
}