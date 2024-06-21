variable "env" {
  description = "environment name"
  type        = string
}

variable "policy_id" {
  description = "policy_id"
  type        = string
}

variable "enabled" {
  description = "enable check"
  type        = bool
  default     = true
}

variable "name" {
  description = "name check"
  type        = string
}

variable "label" {
  description = "label check"
  type        = string
}

variable "period" {
  description = "period"
  type        = string
  default     = "EVERY_5_MINUTES" 
  // EVERY_MINUTE, EVERY_5_MINUTES, EVERY_10_MINUTES, EVERY_15_MINUTES, EVERY_30_MINUTES, EVERY_HOUR, EVERY_6_HOURS, EVERY_12_HOURS, EVERY_DAY
}

variable "type" {
  description = "type check"
  type        = string
  default     = "SIMPLE" // SIMPLE | BROWSER | SCRIPT_API | SCRIPT_BROWSER 
}

variable "private" {
  description = "use private locations"
  type        = bool
  default     = false
}

variable "private_dc" {
  description = "locations private is DC"
  type        = bool
  default     = true // true = DC, false = CA
}

variable "private_dc_jobmanager" {
  description = "locations private is DC, uses new runtime"
  type        = bool
  default     = false // false = old container, true = JobManager
}

variable "locations_public" {
  description = "list public locations"
  type        = list(string)
  default     = ["EU_SOUTH_1", "EU_CENTRAL_1", "EU_WEST_1"] // when private_loc == 0 list of locations []
}

variable "url" {
  description = "url (only for SIMPLE | BROWSER)"
  type        = string
  default     = null
}

variable "validation_string" {
  description = "validation string (only for SIMPLE | BROWSER)"
  type        = string
  default     = null
}

variable "verify_ssl" {
  description = "verify ssl cert (only for SIMPLE | BROWSER)"
  type        = bool
  default     = true
}

variable "script_file" {
  description = "script file (only for SCRIPT_API | SCRIPT_BROWSER)"
  type        = string
  default     = null
}

variable "script_language" {
  description = "script language (only for SCRIPT_API | SCRIPT_BROWSER)"
  type        = string
  default     = null
}

variable "runtime_type" {
  description = "runtime type (only for SCRIPT_API | SCRIPT_BROWSER)"
  type        = string
  default     = null
}

variable "params_map" {
  description = "params map for script tftpl file (only for SCRIPT_API | SCRIPT_BROWSER)"
  type        = map
  default     = null
}

variable "tags" {
  description = "synthetic tags"
  type        = map(any)
  default     = {}
}

variable "disabled_result_check" {
  description = "disabled result check"
  type        = bool
  default     = false
}

variable "result_window" {
  description = "result window"
  type        = number
  default     = null
}

variable "result_expiration" {
  description = "result expiration"
  type        = number
  default     = null
}

variable "result_threshold" {
  description = "result threshold"
  type        = number
  default     = null
}

variable "result_threshold_duration" {
  description = "result threshold_duration"
  type        = number
  default     = null
}

variable "disabled_duration_check" {
  description = "disabled duration check"
  type        = bool
  default     = false
}

variable "duration_window" {
  description = "duration window"
  type        = number
  default     = null
}

variable "duration_expiration" {
  description = "duration expiration"
  type        = number
  default     = null
}

variable "duration_threshold" {
  description = "duration threshold"
  type        = number
  default     = null
}

variable "duration_threshold_duration" {
  description = "duration threshold_duration"
  type        = number
  default     = null
}

variable "duration_timeout" {
  description = "duration timeout"
  type        = number
  default     = null
}

variable "disabled_nodata_check" {
  description = "disabled nodata check"
  type        = bool
  default     = false
}
