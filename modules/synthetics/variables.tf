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

variable "enable_checks" {
  description = "global var to enable checks"
  type        = bool
  default     = false
}

variable "enable_simple_browser_checks" {
  description = "global var to enable simple browser checks"
  type        = bool
  default     = false
}

variable "checks_info" {
  description = "urls to test"
  type = map(object({
    enabled      = bool
    url          = string
    url_num      = number
    label        = string
    service_name = string
    product      = string
    tech_serv    = string
    script       = string
    user         = string
    pass         = string
    freq         = number
    priv_loc     = bool
    multi_loc    = bool
    duration_thr = number
    result_thr   = number
    max_failures = number
  }))
}

variable "API_checks_info" {
  description = "urls to test via API"
  type = map(object({
    enabled      = bool
    url          = string
    url_num      = number
    label        = string
    service_name = string
    product      = string
    tech_serv    = string
    script       = string
    user         = string
    pass         = string
    priv_loc     = bool
    multi_loc    = bool
    duration_thr = number
    result_thr   = number
    max_failures = number
  }))
}

variable "SIMPLE_BROWSER_checks_info" {
  description = "urls to test via simple browser monitors"
  type = map(object({
    enabled      = bool
    url          = string
    url_num      = number
    label        = string
    pattern      = string
    product      = string
    tech_serv    = string
    priv_loc     = bool
    duration_thr = number
    result_thr   = number
    max_failures = number
  }))
  default = {
    1 = {
      enabled      = true
      url          = "default"
      url_num      = 0
      label        = "default"
      pattern      = "default"
      product      = "default"
      tech_serv    = "default"
      priv_loc     = false
      duration_thr = 0
      result_thr   = 1200
      max_failures = 2
    }
  }
}

variable "SIMPLE_BROWSER_CA_checks_info" {
  description = "CA urls to test via simple browser monitors"
  type = map(object({
    enabled      = bool
    url          = string
    url_num      = number
    label        = string
    pattern      = string
    product      = string
    tech_serv    = string
    priv_loc     = bool
    duration_thr = number
    result_thr   = number
    max_failures = number
  }))
  default = {
    1 = {
      enabled      = true
      url          = "default"
      url_num      = 0
      label        = "default"
      pattern      = "default"
      product      = "default"
      tech_serv    = "default"
      priv_loc     = false
      duration_thr = 0
      result_thr   = 1200
      max_failures = 2
    }
  }
}

variable "checks_info_once_day" {
  description = "urls to test once per day"
  type = map(object({
    enabled      = bool
    url          = string
    url_num      = number
    label        = string
    service_name = string
    product      = string
    tech_serv    = string
    script       = string
    user         = string
    pass         = string
    freq         = number
    priv_loc     = bool
    multi_loc    = bool
    duration_thr = number
    result_thr   = number
    max_failures = number
  }))
}

variable "ping_monitors" {
  description = "urls to test via ping"
  type = map(object({
    enabled      = bool
    url          = string
    url_num      = number
    label        = string
    service_name = string
    product      = string
    tech_serv    = string
    freq         = number
    priv_loc     = bool
    priv_loc_ca  = bool
    multi_loc    = bool
    duration_thr = number
    result_thr   = number
    max_failures = number
  }))
}