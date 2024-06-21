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

variable "enable_probe" {
  description = "Enabler of STAMP Dublin probe to monitor STATUS, PING, TIMESTAMPS, MARCHE"
  type        = bool
  default     = false
}

variable "enable_milan_checks" {
  description = "Enabler of STAMP AWS Milan checks"
  type        = bool
  default     = false
}

variable "clusterName" {
  description = "STAMP AWS Milan cluster name"
  type        = string
}

variable "deploymentName" {
  description = "deploymentName"
  type        = string
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

variable "duration_check_type" {
  description = "transaction - high duration check type"
  type        = string
  default     = "baseline"
}

variable "duration_thresh_duration" {
  description = "transactions - high duration threshold: max duration of duration out of treshold"
  type        = number
  default     = 1200
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

variable "enable_log_checks" {
  description = "enable checks on metrics retrieved on STAMP logs"
  type        = bool
  default     = false
}

variable "failure_aggr_method" {
  description = "transactions - high failure rate aggregation method: sampling method to pick aggregated data"
  type        = string
  default     = "event_timer"
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

variable "failure_aggr_window" {
  description = "transactions - high failure rate aggregation window: timeseries size to sample datapoints from"
  type        = number
  default     = 60
}

variable "failure_slide_by" {
  description = "transactions - high failure rate sliding window timeframe"
  type        = number
  default     = 30
}