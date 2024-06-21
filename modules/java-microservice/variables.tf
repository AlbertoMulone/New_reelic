variable "enabled" {
  description = "enable alert conditions"
  type        = bool
  default     = true
}

variable "complete_appname" {
  description = "complete name of the application"
  type        = string
}

variable "alert_policy_id" {
  description = "alert policy id"
  type        = string
}

variable "health_th_duration" {
  description = "duration threshold on how long a health check violation needs to be open before opening an incident"
  type        = number
  default     = 420
}

variable "health_threshold" {
  description = "duration threshold to open an incident"
  type        = number
  default     = 0
}

variable "health_th_occurence" {
  description = "duration threshold occurence policy"
  type        = string
  default     = "all"
}

variable "nodata_aggr_window" {
  description = "no data health check aggregation window: sample timeframe size to check whether the violation occures"
  type        = number
  default     = 900
}

variable "health_fill_option" {
  description = "health check fill option to replenish data lacking timeframes"
  type        = string
  default     = "last_value"
}

variable "health_aggr_window" {
  description = "health check aggregation window: sample timeframe size to check whether the violation occures"
  type        = number
  default     = 300
}

variable "health_aggr_method" {
  description = "health check aggregation method: sampling method to pick aggregated data"
  type        = string
  default     = "event_flow"
}

variable "health_aggr_timer" {
  description = "health check aggregation timer: samples granularity, used on event_timer aggr method"
  type        = number
  default     = null
}

variable "health_aggr_delay" {
  description = "health check aggregation delay: time to wait for next resampling before firing alert"
  type        = number
  default     = null
}

variable "health_exp_duration" {
  description = "health check expiration duration: after how long should an alert expire"
  type        = number
  default     = 300
}

