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
  description = "icsscore label"
  type        = string
}

variable "service_name" {
  description = "icsscore service_name"
  type        = string
}

variable "process_count" {
  description = "instances that should run"
  type        = number
  default     = 1
}