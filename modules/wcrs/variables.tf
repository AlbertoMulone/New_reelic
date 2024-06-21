variable "env" {
  description = "environment name"
  type        = string
}

variable "network_envs" {
  description = "infocert network environments"
  type        = list(string)
  default     = []
}

variable "notification" {
  description = "set notification channel"
  type        = string
}

variable "enable_API_checks" {
  description = "global var to enable scripted API checks"
  type        = bool
  default     = false
}

variable "wcrs_scripted_API_checks" {
  description = "urls to test via scripted API"
  type = map(object({
    enabled       = bool
    url           = string
    label         = string
    code          = number
    check_string  = string
    authorization = string
    script        = string
    user          = string
    pass          = string
    priv_loc      = bool
    frequency     = number
    duration_thr  = number
    result_thr    = number
  }))
}