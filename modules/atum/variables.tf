variable "env" {
  description = "environment name"
  type        = string
}

variable "env_newrelic" {
  description = "environment name according to newrelic"
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

variable "clusterName" {
  description = "ATUM AWS cluster name"
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

variable "synthetics_map" {
  description = "map of synthetics monitors"
  type = any
  default = {}
}