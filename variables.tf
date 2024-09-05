variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
  default     = "" # Default to empty, will use environment TF_VAR_hcloud_token variable if set
}

variable "network_ip_range" {
  description = "The IP range for the Hetzner Cloud network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_ip_range" {
  description = "The IP range for the Hetzner Cloud network subnet."
  type        = string
  default     = "10.0.0.0/24"
}

variable "prefix" {
  description = "Prefix for all resources."
  type        = string
  default     = "k8s"
}

variable "network_zone" {
  description = "The Hetzner Cloud network zone for the subnet."
  type        = string
  default     = "us-east"

  validation {
    condition     = contains(["eu-central", "us-east", "us-west", "ap-southeast"], var.network_zone)
    error_message = "Invalid network zone. Must be one of: eu-central, us-east, us-west, ap-southeast."
  }
}

variable "server_location" {
  description = "The location name to create the server in."
  type        = string
  default     = "ash"

  validation {
    condition     = contains(["fsn1", "nbg1", "hel1", "ash", "hil", "sin"], var.server_location)
    error_message = "Invalid server location. Must be one of: fsn1, nbg1, hel1, ash, hil, sin."
  }
}

variable "server_count" {
  description = "The number of servers to create."
  type        = number
  default     = 3
}

variable "server_image" {
  description = "The image to use for the servers."
  type        = string
  default     = "ubuntu-24.04"
}

variable "server_type" {
  description = "The type of server to create."
  type        = string
  default     = "cpx11"
}

variable "kubernetes_version" {
  description = "Kubernetes component version"
  type        = string
  default     = "1.31"
}
