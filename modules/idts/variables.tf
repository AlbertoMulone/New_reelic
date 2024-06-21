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
  default     = "idts"
}

variable "service_name" {
  description = "service name"
  type        = string
}

variable "enable_probe" {
  description = "enable of IDTS probe to monitor STATUS, PING, TIMESTAMP, ALTEPERFORMANCE, MARCHE"
  type        = bool
  default     = false
}

variable "app_name" {
  description = "APM instance name on NewRelic console"
  type        = string
}

variable "enable_nagios" {
  description = "enable nagios checks"
  type        = bool
  default     = false
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

variable "failure_aggr_method" {
  description = "transactions - high failure rate aggregation method: sampling method to pick aggregated data"
  type        = string
  default     = "event_flow"
}

variable "failure_aggr_timer" {
  description = "transactions - high failure rate aggregation timer: samples granularity, used on event_timer aggr method"
  type        = number
  default     = null
}

variable "failure_aggr_delay" {
  description = "transactions - high failure rate aggregation delay: time to wait for next resampling before firing alert"
  type        = number
  default     = null
}

variable "failure_slide_by" {
  description = "transactions - high failure rate sliding window timeframe"
  type        = number
  default     = null
}

variable "synthetics_map" {
  description = "map of synthetics monitors"
  type = any
  default = {}
}

