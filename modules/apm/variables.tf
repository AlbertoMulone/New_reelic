variable "policy_id" {
  description = "policy_id"
  type        = string
}

variable "filter_app" {
  description = "NRQL query filter for metrics calculation depending on app name"
  type        = string
}

variable "filter_trnsct" {
  description = "NRQL query filter for metrics calculation depending on transaction name"
  type        = string
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
  description = "enable alert high duration"
  type        = bool
  default     = true
}

variable "duration_thresh_crt" {
  description = "high transactions duration threshold: number of st_dev"
  type        = number
  default     = 10
}

variable "duration_thresh_duration" {
  description = "high transactions duration threshold: duration of duration treshold"
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
  description = "enable alert high failure rate"
  type        = bool
  default     = true
}

variable "failure_thresh_crt" {
  description = "high failure rate threshold [percentage]"
  type        = number
  default     = 0.25
}
/*
variable "high_failure_duration" {
  description = "high failure rate duration"
  type        = number
  default     = 15
}
*/

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