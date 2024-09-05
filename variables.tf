variable "hcloud_token" {
  description = "API token for Hetzner Cloud."
  type        = string
  sensitive   = true
  default     = "" # Use TF_VAR_hcloud_token environment variable
}

variable "network_ip_range" {
  description = "IP range for the cloud network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_ip_range" {
  description = "IP range for the network subnet."
  type        = string
  default     = "10.0.0.0/24"
}

variable "prefix" {
  description = "Resource name prefix."
  type        = string
  default     = "k8s"
}

variable "network_zone" {
  description = "Network zone for the subnet."
  type        = string
  default     = "us-east"

  validation {
    condition     = contains(["eu-central", "us-east", "us-west", "ap-southeast"], var.network_zone)
    error_message = "Invalid network zone. Must be one of: eu-central, us-east, us-west, ap-southeast."
  }
}

variable "server_location" {
  description = "Server location."
  type        = string
  default     = "ash"

  validation {
    condition     = contains(["fsn1", "nbg1", "hel1", "ash", "hil", "sin"], var.server_location)
    error_message = "Invalid server location. Must be one of: fsn1, nbg1, hel1, ash, hil, sin."
  }
}

variable "server_count" {
  description = "Number of servers."
  type        = number
  default     = 3
}

variable "server_image" {
  description = "Image for server instances."
  type        = string
  default     = "ubuntu-24.04"
}

variable "server_type" {
  description = "Type of server instance."
  type        = string
  default     = "cpx11"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes."
  type        = string
  default     = "1.31"
}

