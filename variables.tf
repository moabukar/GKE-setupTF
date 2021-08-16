variable "region" {
  description = "GCP region identifier"
  type        = string
}

variable "zones" {
  description = "GCP zone identifier"
  type        = list
}

variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "host_project" {
  description = "shared vpc name"
  type        = string
  default     = "shared_vpc_project"
}

variable "watchman_token" {
  type = string
}

variable "network" {
  description = "Network to deploy to. Only one of network or subnetwork should be specified."
  default     = ""
}

variable "subnetwork" {
  description = "Subnet to deploy to. Only one of network or subnetwork should be specified."
  default     = ""
}

variable "subnet_2" {
  description = "Subnet to deploy to. Only one of network or subnetwork should be specified."
  default     = ""
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  default     = "false"
}

variable "target_pools" {
  description = "The target load balancing pools to assign this group to."
  type        = list(string)
  default     = []
}