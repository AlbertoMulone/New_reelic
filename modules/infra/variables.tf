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

variable "violation_close_timer" {
  description = "infra violation_close_timer"
  type        = number
  default     = 72
}

# host not reporting
variable "enable_host_not_reporting" {
  description = "enable host not reporting"
  type        = bool
  default     = true
}

# high cpu
variable "enable_high_cpu_usage" {
  description = "enable alert high cpu usage"
  type        = bool
  default     = true
}

variable "high_cpu_usage_percent" {
  description = "high cpu usage percent error"
  type        = number
  default     = 90
}

variable "high_cpu_usage_duration" {
  description = "high cpu usage duration error"
  type        = number
  default     = 15
}

# high disk
variable "enable_high_disk_usage" {
  description = "enable alert high disk usage"
  type        = bool
  default     = true
}

variable "high_disk_usage_percent" {
  description = "high disk usage percent error"
  type        = number
  default     = 90
}

variable "high_disk_usage_duration" {
  description = "high disk usage duration error"
  type        = number
  default     = 15
}

# high memory
variable "enable_high_memory_usage" {
  description = "enable alert high memory usage"
  type        = bool
  default     = true
}

variable "high_memory_usage_percent" {
  description = "high memory usage percent error"
  type        = number
  default     = 90
}

variable "high_memory_usage_duration" {
  description = "high memory usage duration error"
  type        = number
  default     = 15
}

# fs read only
variable "enable_fs_read_only" {
  description = "enable alert filesystem read only"
  type        = bool
  default     = false
}

# high disk inode
variable "enable_disk_inode_usage" {
  description = "enable alert disk inode usage"
  type        = bool
  default     = false
}

variable "high_disk_inode_usage_percent" {
  description = "high disk inode usage percent error"
  type        = number
  default     = 90
}

variable "high_disk_inode_usage_duration" {
  description = "high disk inode usage duration error"
  type        = number
  default     = 900
}
