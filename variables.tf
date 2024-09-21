# variables.tf - Removed the locals block and updated the validation to directly include valid versions

variable "hcloud_token" {
  description = <<-DESC
    (Required) API token for Hetzner Cloud.
    Use the environment variable TF_VAR_hcloud_token if you prefer not to hard-code this value.
  DESC
  type        = string
  sensitive   = true
  default     = ""
}

variable "image" {
  description = <<-DESC
    (Required) The image to use for server instances.
    Default: "ubuntu-24.04"
  DESC
  type        = string
  default     = "ubuntu-24.04"
}

variable "kubernetes_version" {
  description = <<-DESC
    (Required) The version of Kubernetes to deploy on the server instances.
    Default: "1.31"

    Options:
    - "1.31"
    - "1.32"
  DESC
  type        = string
  default     = "1.31"

  validation {
    condition     = contains(["1.31", "1.32"], var.kubernetes_version)
    error_message = "Invalid Kubernetes version. Supported versions are: 1.31, 1.32. You provided: ${var.kubernetes_version}"
  }
}

variable "location" {
  description = <<-DESC
    (Required) The location for the server instances.

    Options include:
    - fsn1
    - nbg1
    - hel1
    - ash
    - hil
    - sin
  DESC
  type        = string
  default     = "ash"

  validation {
    condition     = contains(["fsn1", "nbg1", "hel1", "ash", "hil", "sin"], var.location)
    error_message = "Invalid server location. Must be one of: fsn1, nbg1, hel1, ash, hil, sin."
  }
}

variable "network_ip_range" {
  description = <<-DESC
    (Required) IP range for the cloud network.
    Default: "10.0.0.0/16"
  DESC
  type        = string
  default     = "10.0.0.0/16"
}

variable "network_zone" {
  description = <<-DESC
    (Required) The network zone for the subnet.

    Options include:
    - eu-central
    - us-east
    - us-west
    - ap-southeast
  DESC
  type        = string
  default     = "us-east"

  validation {
    condition     = contains(["eu-central", "us-east", "us-west", "ap-southeast"], var.network_zone)
    error_message = "Invalid network zone. Must be one of: eu-central, us-east, us-west, ap-southeast."
  }
}

variable "prefix" {
  description = <<-DESC
    (Required) A prefix for naming resources.
    Default: "dev"
  DESC
  type        = string
  default     = "dev"
}

variable "server_count" {
  description = <<-DESC
    (Required) The number of servers to create.
    Default: 3
  DESC
  type        = number
  default     = 3
}

variable "subnet_ip_range" {
  description = <<-DESC
    (Required) IP range for the network subnet.
    Default: "10.0.0.0/24"
  DESC
  type        = string
  default     = "10.0.0.0/24"
}

variable "type" {
  description = <<-DESC
    (Required) The type of server instance to create.
    Default: "cpx11"
  DESC
  type        = string
  default     = "cpx11"
}

