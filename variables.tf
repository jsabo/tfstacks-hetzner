variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
  default     = "" # Default to empty, will use environment TF_VAR_hcloud_token variable if set
}

variable "prefix" {
  description = "Prefix for all resources."
  type        = string
  default     = "neu"
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

variable "network_zone" {
  description = "The Hetzner Cloud network zone for the subnet."
  type        = string
  default     = "eu-central"
}

variable "server_location" {
  description = "The location name to create the server in."
  type        = string
  default     = "nbg1"
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
  default     = "cax11"
}
