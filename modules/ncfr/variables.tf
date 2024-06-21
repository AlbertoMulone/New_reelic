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
/*
variable "basename" {
  description = "base name of the application"
  type        = string
  default     = "ncfr"
}*/

variable "enable_apache_checks" {
  description = "Enabler of checks related to apache log data"
  type        = bool
  default     = false
}

variable "apache_checks_info" {
  description = "Details related to each apache front-end log to monitor"
  type = map(object({
    net_env      = string
    tag          = string
    elaps_thresh = number
  }))
  default = {
    1 = {
      net_env      = "default"
      tag          = "default"
      elaps_thresh = 0
    }
  }
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
  default     = null
}

variable "enable_APM_duration_check" {
  description = "enable APM alert condition: response time"
  type        = bool
  default     = false
}

variable "duration_thresh_crt" {
  description = "high transactions duration threshold: number of st_dev"
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

variable "duration_thresh_duration" {
  description = "high transactions duration threshold: duration of duration treshold"
  type        = number
  default     = 420
}

variable "duration_aggregation_delay" {
  description = "high transactions duration: aggregation delay"
  type        = number
  default     = 120
}

variable "duration_aggregation_window" {
  description = "high transactions duration: aggregation window"
  type        = number
  default     = 60
}

variable "duration_slide_by" {
  description = "high transactions duration: sliding window timeframe"
  type        = number
  default     = null
}

variable "synthetics_map" {
  description = "map of synthetics monitors"
  type = any
  default = {}
}