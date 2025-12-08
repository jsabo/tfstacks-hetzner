# tfstacks-hetzner

Kubernetes lab environment that can be spun up in two places:

- **Hetzner Cloud** (via OpenTofu/Terraform)
- **Local VMs on macOS** (via Multipass)

Both environments use the same `cloud-init` template so you get a consistent Kubernetes-ready node layout everywhere.

---

## Components

- **Hetzner infrastructure**
  - `main.tf`, `providers.tf`, `variables.tf`, `outputs.tf`
  - Creates a private network and a set of Ubuntu servers, prepped for Kubernetes
- **Cloud-init**
  - `cloud-init.tftpl` – parameterized template used by Hetzner and Multipass
- **Ansible**
  - `ansible.cfg` – points at dynamic inventories
  - `hcloud.yml` – Hetzner dynamic inventory plugin
  - `multipass_inventory.py` – dynamic inventory for Multipass VMs
  - `test-playbook.yml` – simple connectivity + privilege sanity check

---

## Prerequisites

On your local machine:

- OpenTofu or Terraform (`tofu` is assumed in examples)
- Ansible
- Python 3
- Multipass (macOS)
- `envsubst` (`gettext` package on macOS)
- SSH key pair (e.g. `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`)
- Hetzner Cloud account + API token

Environment:

```bash
export TF_VAR_hcloud_token="<your-hetzner-token>"   # or set in a tfvars file
export HCLOUD_TOKEN="$TF_VAR_hcloud_token"          # used by hcloud.yml
````

---

## 1. Provision Hetzner Kubernetes Nodes

From the repo root:

```bash
tofu init --upgrade
tofu apply --auto-approve
```

This will:

* Create a Hetzner network + subnet
* Create `server_count` nodes (see `variables.tf`)
* Inject your SSH key into each node
* Use `cloud-init.tftpl` to:

  * Harden SSH
  * Configure kernel modules and sysctl for Kubernetes
  * Install containerd, kubelet, kubeadm, kubectl
  * Configure `containerd` to use systemd cgroups

To tear it down later:

```bash
tofu destroy --auto-approve
```

---

## 2. Launch Local Multipass Kubernetes Nodes

You can reuse the same `cloud-init.tftpl` with Multipass by rendering it locally (replacing `${ssh_key}` and `${kubernetes_version}`) and passing the result to `multipass launch`.

Example pattern:

```bash
SSH_KEY="$(cat ~/.ssh/id_rsa.pub)"
K8S_VERSION="1.34"

env ssh_key="$SSH_KEY" kubernetes_version="$K8S_VERSION" \
  envsubst < cloud-init.tftpl > /tmp/cloud-init-rendered.yml

multipass launch \
  --name node-1 \
  --memory 4G \
  --disk 20G \
  --cpus 2 \
  --cloud-init /tmp/cloud-init-rendered.yml \
  24.04
```

Repeat with `node-2`, `node-3`, etc., or wrap this in a small shell script if you haven’t already.

---

## 3. Ansible Inventory & Usage

### Inventory sources

`ansible.cfg` is configured to use:

* `hcloud.yml` – discovers Hetzner nodes and exposes groups like `label_environment_<prefix>`
* `multipass_inventory.py` – discovers running Multipass instances and puts them in group **`multipass`**

Check the combined inventory:

```bash
ansible-inventory --graph
```

You should see groups like:

* `multipass` (local VMs)
* `label_environment_dev` (Hetzner nodes when `prefix = "dev"`)

### Basic checks

Ping all known hosts:

```bash
ansible -m ping all
```

Ping only Multipass nodes:

```bash
ansible multipass -m ping
```

Ping only Hetzner “dev” nodes:

```bash
ansible label_environment_dev -m ping
```

### Run the test playbook

Simple health check (facts, ping, `id` as root):

```bash
ansible-playbook test-playbook.yml
```

Limit to a specific group:

```bash
ansible-playbook -l multipass test-playbook.yml
ansible-playbook -l label_environment_dev test-playbook.yml
```

---

## 4. Interactive Access

### Hetzner nodes

```bash
ssh -l ubuntu $(hcloud server ip dev-node-1)
ssh -l ubuntu $(hcloud server ip dev-node-2)
ssh -l ubuntu $(hcloud server ip dev-node-3)
```

### Multipass nodes

```bash
multipass list   # find IPs / names

ssh ubuntu@<multipass-node-ip>
# or, if you have hostnames in /etc/hosts or use mDNS:
ssh ubuntu@node-1
```

---

## 5. Cleaning Up

### Hetzner

```bash
tofu destroy --auto-approve
```

### Multipass

```bash
multipass delete --all
multipass purge
```

---

## Notes

* Kubernetes minor version is controlled via `kubernetes_version` (Terraform variable and `cloud-init.tftpl` placeholder).
* SSH access is **pubkey-only** by design. Make sure the key injected into `cloud-init.tftpl` matches the key you use locally.
* The same cloud-init logic is shared between cloud (Hetzner) and local (Multipass) to keep your lab environments consistent.
