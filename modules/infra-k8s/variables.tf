variable "policy_id" {
  description = "policy_id"
  type        = string
}

variable "filter" {
  description = "filter"
  type        = string
}

variable "enabled" {
  description = "enable alert conditions"
  type        = bool
  default     = true
}

variable "enable_fs_read_only" {
  description = "enable alert filesystem read only"
  type        = bool
  default     = false
}

variable "high_cpu_usage_percent" {
  description = "high cpu usage percent error"
  type        = number
  default     = 95
}

variable "high_memory_usage_percent" {
  description = "high memory usage percent error"
  type        = number
  default     = 90
}

variable "high_fs_usage_percent" {
  description = "high fs usage percent error"
  type        = number
  default     = 90
}

variable "enable_fs_usage_check" {
  description = "enable alert filesystem usage"
  type        = bool
  default     = true
}