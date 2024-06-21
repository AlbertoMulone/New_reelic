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

variable "enable_p12_check" {
  description = "enable p12 certificates check"
  type        = bool
  default     = false
}

variable "p12_gen_aggr_method" {
  description = "p12 generic error: sampling method to pick aggregated data"
  type        = string
  default     = "event_timer"
}

variable "p12_gen_aggr_timer" {
  description = "p12 generic error: samples granularity, used on event_timer aggr method"
  type        = number
  default     = 1200
}

variable "p12_gen_aggr_window" {
  description = "p12 generic error: sample timeframe size to check whether the violation occures"
  type        = number
  default     = 7200
}

variable "p12_gen_exp_duration" {
  description = "p12 generic error: after how long should an alert expire"
  type        = number
  default     = 172800
}

variable "p12_gen_thresh_duration" {
  description = "p12 generic error: threshold on how long a health check violation needs to be open before opening an incident"
  type        = number
  default     = 7200
}

