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
  default     = "nova"
}

variable "enable_APM_failure_check" {
  description = "enable APM alert condition: failure rate"
  type        = bool
  default     = false
}

variable "failure_thresh_crt" {
  description = "transactions - high failure rate threshold: number of st_dev"
  type        = number
  default     = 10
}

variable "failure_thresh_duration" {
  description = "transactions - high failure rate duration: max duration of failure rate out of treshold"
  type        = number
  default     = 600
}

variable "failure_slide_by" {
  description = "transactions - high failure rate sliding window timeframe"
  type        = number
  default     = 30
}

variable "enable_APM_duration_check" {
  description = "enable APM alert condition: response time"
  type        = bool
  default     = false
}

variable "duration_thresh_crt" {
  description = "transactions - high duration threshold: number of st_dev"
  type        = number
  default     = 10
}

variable "enable_APM_db_check" {
  description = "enable APM alert condition: database"
  type        = bool
  default     = false
}

variable "db_resp_time_thresh" {
  description = "threshold for APM alert condition: database resp time"
  type        = number
  default     = 100
}

variable "db_type" {
  description = "DB family used by the application"
  type        = string
  default     = "MongoDB"
}

variable "db_transaction_type" {
  description = "DB transaction name related to db technology"
  type        = string
  default     = "operation"
}

variable "enable_APM_apdex_check" {
  description = "enable APM alert condition: database"
  type        = bool
  default     = false
}

variable "apdex_thresh" {
  description = "threshold for APM alert condition: apdex"
  type        = number
  default     = 0.75
}

variable "apdex_thresh_duration" {
  description = "low apdex violation minimum duration in order to open an incident"
  type        = number
  default     = 300
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