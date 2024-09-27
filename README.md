# tfstatcks-hetzner

## Usage

Deploy Stack

```
tofu init --upgrade
tofu apply --auto-approve
```

Run Ansible Tasks

```
ansible -m ping all
```

Run Ansible Playbooks

```
ansible-inventory --graph
ansible-playbook test-playbook.yml
ansible-playbook create-cluster-kubeadm-playbook.yml
```

Interactive Access

```
ssh -l hcloud $(hcloud server ip dev-node-1)
ssh -l hcloud $(hcloud server ip dev-node-2)
ssh -l hcloud $(hcloud server ip dev-node-3)
```

Reset Cluster

```
ansible-playbook reset-cluster-kubeadm-playbook.yml
```

Cleanup

```
tofu destroy --auto-approve
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | ~> 1.48.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | 1.48.1 |

## Resources

| Name | Type |
|------|------|
| [hcloud_network.private](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network) | resource |
| [hcloud_network_subnet.subnet](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/network_subnet) | resource |
| [hcloud_server.node](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server) | resource |
| [hcloud_ssh_key.default](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/ssh_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | (Required) API token for Hetzner Cloud.<br>Use the environment variable TF\_VAR\_hcloud\_token if you prefer not to hard-code this value. | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | (Required) The image to use for server instances.<br>Default: "ubuntu-24.04" | `string` | `"ubuntu-24.04"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (Required) The version of Kubernetes to deploy on the server instances.<br>Default: "1.31"<br><br>Options:<br>- "1.31"<br>- "1.32" | `string` | `"1.31"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location for the server instances.<br><br>Options include:<br>- fsn1<br>- nbg1<br>- hel1<br>- ash<br>- hil<br>- sin | `string` | `"ash"` | no |
| <a name="input_network_ip_range"></a> [network\_ip\_range](#input\_network\_ip\_range) | (Required) IP range for the cloud network.<br>Default: "10.0.0.0/16" | `string` | `"10.0.0.0/16"` | no |
| <a name="input_network_zone"></a> [network\_zone](#input\_network\_zone) | (Required) The network zone for the subnet.<br><br>Options include:<br>- eu-central<br>- us-east<br>- us-west<br>- ap-southeast | `string` | `"us-east"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | (Required) A prefix for naming resources.<br>Default: "dev" | `string` | `"dev"` | no |
| <a name="input_server_count"></a> [server\_count](#input\_server\_count) | (Required) The number of servers to create.<br>Default: 3 | `number` | `3` | no |
| <a name="input_subnet_ip_range"></a> [subnet\_ip\_range](#input\_subnet\_ip\_range) | (Required) IP range for the network subnet.<br>Default: "10.0.0.0/24" | `string` | `"10.0.0.0/24"` | no |
| <a name="input_type"></a> [type](#input\_type) | (Required) The type of server instance to create.<br>Default: "cpx11" | `string` | `"cpx11"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | The ID of the created Hetzner Cloud network. |
| <a name="output_server_ips"></a> [server\_ips](#output\_server\_ips) | The IP addresses of all created servers. |
<!-- END_TF_DOCS -->
