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

variable "basename" {
  description = "base name of the application"
  type        = string
  default     = "wormhole"
}

variable "health_th_duration" {
  description = "duration threshold on how long a health check violation needs to be open before opening an incident"
  type        = number
  default     = 300
}

variable "health_threshold" {
  description = "duration threshold to open an incident"
  type        = number
  default     = 4
}

variable "health_th_occurence" {
  description = "duration threshold occurence policy"
  type        = string
  default     = "at_least_once"
}

variable "health_aggr_delay" {
  description = "health check aggregation delay: time to wait for next resampling before firing alert"
  type        = number
  default     = 10
}

variable "synthetics_map" {
  description = "map of synthetics monitors"
  type = any
  default = {}
}