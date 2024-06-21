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

variable "label" {
  description = "stargate label"
  type        = string
}

variable "deploymentName" {
  description = "deploymentName"
  type        = string
}

variable "clusterName" {
  description = "clusterName"
  type        = string
}

variable "labels_release" {
  description = "labels_release"
  type        = string
}
