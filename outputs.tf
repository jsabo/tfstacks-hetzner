# outputs.tf - Contains all output declarations

output "network_id" {
  description = "The ID of the created Hetzner Cloud network."
  value       = hcloud_network.private.id
}

output "server_ips" {
  description = "The IP addresses of all created servers."
  value       = [for server in hcloud_server.node : server.ipv4_address]
}

