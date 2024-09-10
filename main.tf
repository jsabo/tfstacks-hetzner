resource "hcloud_network" "private_network" {
  name     = "${var.prefix}-network"
  ip_range = var.network_ip_range
}

resource "hcloud_network_subnet" "private_network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.private_network.id
  network_zone = var.network_zone
  ip_range     = var.subnet_ip_range
}

resource "hcloud_ssh_key" "default" {
  name       = "default ssh key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_server" "node" {
  count       = var.server_count
  name        = "${var.prefix}-node-${count.index + 1}"
  image       = var.server_image
  server_type = var.server_type
  location    = var.server_location

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.private_network.id
    ip         = cidrhost(hcloud_network_subnet.private_network_subnet.ip_range, count.index + 11)
    alias_ips  = []
  }

  labels = {
    "environment" : "${var.prefix}"
  }

  ssh_keys = [hcloud_ssh_key.default.name]

  user_data = templatefile("${path.module}/cloud-init.tftpl", {
    kubernetes_version = var.kubernetes_version
    ssh_key            = hcloud_ssh_key.default.public_key
  })

  depends_on = [hcloud_network_subnet.private_network_subnet]
}
