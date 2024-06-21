variable "enabled" {
  description = "enable alert conditions"
  type        = bool
  default     = true
}

variable "network_envs" {
  description = "infocert network environments"
  type        = list(string)
}

variable "alert_policy_id" {
  description = "alert policy id"
  type        = string
}

variable "service_name" {
  description = "service_name"
  type        = string
}

variable "jboss_instances" {
  description = "jboss instances"
  type        = list(string)
}