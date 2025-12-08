# main.tf - Contains all primary resource declarations

resource "hcloud_network" "private" {
  name     = "${var.prefix}-network"
  ip_range = var.network_ip_range
}

resource "hcloud_network_subnet" "subnet" {
  type         = "cloud"
  network_id   = hcloud_network.private.id
  network_zone = var.network_zone
  ip_range     = var.subnet_ip_range
}

resource "hcloud_ssh_key" "default" {
  name       = "default_ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_server" "node" {
  count       = var.server_count
  name        = "${var.prefix}-node-${count.index + 1}"
  image       = var.image
  server_type = var.type
  location    = var.location

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.private.id
    ip         = cidrhost(hcloud_network_subnet.subnet.ip_range, count.index + 11)
    alias_ips  = []
  }

  labels = {
    environment = var.prefix
  }

  ssh_keys = [hcloud_ssh_key.default.name]

  user_data = templatefile("${path.module}/cloud-init.tftpl", {
    kubernetes_version = var.kubernetes_version
    ssh_key            = hcloud_ssh_key.default.public_key
  })

  depends_on = [hcloud_network_subnet.subnet]
}

