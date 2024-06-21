variable "env" {
  description = "environment name"
  default     = ""
}

variable "product" {
  description = "product name"
  default = null
}

variable "policy_id" {
  description = "alert policy id to put conditions in"
  default = null
}

variable "synthetics_map" {
  description = "map of synthetics monitors"
  type = any
  default = {}
}