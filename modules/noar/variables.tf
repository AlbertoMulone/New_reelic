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

variable "label" {
  description = "label identifying cluster"
  type        = string
}

variable "basename" {
  description = "base name of the application"
  type        = string
  default     = "noar"
}

variable "synthetics_map" {
  description = "map of synthetics monitors"
  type = any
  default = {}
}