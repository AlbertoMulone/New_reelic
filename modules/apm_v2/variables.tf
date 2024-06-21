variable "policy_id" {
  description = "policy_id"
  type        = string
}

variable "filter_app" {
  description = "NRQL query filter for metrics calculation depending on app name"
  type        = string
}

variable "filter_split_dur" {
  description = "NRQL query split between result and duration statements"
  type        = bool
  default     = false
}

variable "filter_trnsct" {
  description = "NRQL query filter for metrics calculation depending on transaction name"
  type        = string
}

variable "filter_trnsct_dur" {
  description = "NRQL query filter depending on transaction name (duration specific)"
  type        = string
  default     = ""
}

variable "enabled" {
  description = "enable alert conditions"
  type        = bool
  default     = true
}

# APDEX
variable "enable_APM_apdex_check" {
  description = "enable alert low apdex"
  type        = bool
  default     = false
}

variable "apdex_thresh_crt" {
  description = "low apdex score threshold"
  type        = number
  default     = 0.75
}

variable "apdex_thresh_duration" {
  description = "low apdex violation minimum duration in order to open an incident"
  type        = number
  default     = 300
}

/*
variable "low_apdex_duration" {
  description = "low apdex duration"
  type        = number
  default     = 15
}
*/

# duration
variable "enable_APM_duration_check" {
  description = "enable alert slow transactions"
  type        = bool
  default     = true
}

variable "duration_check_type" {
  description = "transaction - high duration check type"
  type        = string
  default     = "baseline"
}

variable "duration_aggregation_delay" {
  description = "transaction - high duration aggregation delay"
  type        = number
  default     = 120
}

variable "duration_aggregation_window" {
  description = "transaction - high duration aggregation window"
  type        = number
  default     = 60
}

variable "duration_slide_by" {
  description = "transaction - high duration sliding window timeframe"
  type        = number
  default     = null
}

variable "duration_thresh_crt" {
  description = "transactions - high duration threshold: number of st_dev"
  type        = number
  default     = 10
}

variable "duration_thresh_duration" {
  description = "transactions - high duration threshold: max duration of duration out of treshold"
  type        = number
  default     = 1200
}

/*
variable "high_duration_duration" {
  description = "high duration duration"
  type        = number
  default     = 15
}
*/

# failure rate
variable "enable_APM_failure_check" {
  description = "enable alert too many errors"
  type        = bool
  default     = true
}

variable "failure_thresh_crt" {
  description = "transactions - high failure rate threshold: number of st_dev"
  type        = number
  default     = 10
}

variable "failure_thresh_duration" {
  description = "transactions - high failure rate duration: max duration of failure rate out of treshold"
  type        = number
  default     = 1200
}

variable "failure_aggr_delay" {
  description = "transactions - high failure rate aggregation delay: time to wait for next resampling before firing alert"
  type        = number
  default     = null
}

variable "failure_aggr_method" {
  description = "transactions - high failure rate aggregation delay: time to wait for next resampling before firing alert"
  type        = string
  default     = "event_timer"
}

variable "failure_aggr_timer" {
  description = "transactions - high failure rate aggregation timer: samples granularity, used on event_timer aggr method"
  type        = number
  default     = 60
}

variable "failure_slide_by" {
  description = "transactions - high failure rate sliding window timeframe"
  type        = number
  default     = null
}

variable "failure_aggr_window" {
  description = "transactions - high failure rate aggregation window"
  type        = number
  default     = 60
}

# database connections
variable "enable_APM_db_check" {
  description = "enable DB alert condition"
  type        = bool
  default     = false
}

variable "db_resp_time_thresh" {
  description = "db high response time threshold [ms]"
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