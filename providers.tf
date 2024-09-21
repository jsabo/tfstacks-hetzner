# providers.tf - Contains provider requirements and configuration

terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.48.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

