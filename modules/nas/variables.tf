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

variable "enable_CDAM_check" {
  description = "var to enable number of CDAM marche directories on dedicated NAS"
  type        = bool
  default     = false
}
variable "marche_cdam_thresh" {
  description = "thresh on number of CDAM marche dirs"
  type        = number
  default     = 200000
}

variable "disk_used_thresh" {
  description = "thresh on used persentage of nfs disks"
  type        = number
  default     = 95
}