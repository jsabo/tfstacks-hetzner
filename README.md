# tfstacks-hetzner

Kubernetes lab that can run in two places:

- **Hetzner Cloud** (OpenTofu/Terraform)
- **Local VMs on macOS** (Multipass)

Both use the same `cloud-init.tftpl` so nodes are configured consistently.

---

## Layout

- **Terraform / Hetzner**
  - `main.tf`, `providers.tf`, `variables.tf`, `outputs.tf`
  - `cloud-init.tftpl` – shared cloud-init template
- **Multipass**
  - `create-multipass-nodes.sh` – launches local Kubernetes-ready VMs
- **Ansible**
  - `ansible.cfg` – uses `hcloud.yml` + `multipass_inventory.py`
  - `hcloud.yml` – Hetzner dynamic inventory
  - `multipass_inventory.py` – Multipass dynamic inventory (group: `multipass`)
  - `test-playbook.yml` – simple connectivity/privilege check

---

## Prereqs

- OpenTofu/Terraform (`tofu` in examples)
- Ansible + Python 3
- Multipass (on macOS)
- `envsubst` (from `gettext`)
- SSH key pair (e.g. `~/.ssh/id_rsa.pub`)
- Hetzner Cloud account + API token

Environment:

```bash
export TF_VAR_hcloud_token="<your-hetzner-token>"
export HCLOUD_TOKEN="$TF_VAR_hcloud_token"
````

---

## 1. Hetzner: Create Kubernetes Nodes

From repo root:

```bash
tofu init --upgrade
tofu apply --auto-approve
```

This will:

* Create a Hetzner network + subnet
* Create `server_count` Ubuntu servers
* Inject your SSH key
* Run `cloud-init.tftpl` to:

  * Harden SSH
  * Set up kernel modules + sysctl
  * Install containerd, kubelet, kubeadm, kubectl
  * Configure containerd to use systemd cgroups

Destroy when done:

```bash
tofu destroy --auto-approve
```

---

## 2. Multipass: Create Local Kubernetes Nodes

The script `create-multipass-nodes.sh`:

* Renders `cloud-init.tftpl` with:

  * `ssh_key` from `SSH_KEY_FILE` (defaults to `~/.ssh/id_rsa.pub`)
  * `kubernetes_version` from `K8S_VERSION` (defaults to `1.34`)
* Launches `NODES` Multipass VMs with that cloud-init

Example:

```bash
chmod +x create-multipass-nodes.sh

# 2 nodes (default)
./create-multipass-nodes.sh

# 4 nodes with a different Kubernetes minor
K8S_VERSION=1.35 ./create-multipass-nodes.sh 4
```

List VMs:

```bash
multipass list
```

---

## 3. Ansible: Inventory & Usage

`ansible.cfg`:

```ini
[defaults]
interpreter_python = auto_silent
inventory = ./hcloud.yml, ./multipass_inventory.py
remote_user = ubuntu
```

So Ansible sees:

* Hetzner hosts via `hcloud.yml` (groups like `label_environment_dev`)
* Multipass hosts via `multipass_inventory.py` (group: `multipass`)

Inspect inventory:

```bash
ansible-inventory --graph
```

Ping everything:

```bash
ansible -m ping all
```

Only Multipass:

```bash
ansible multipass -m ping
```

Only Hetzner “dev”:

```bash
ansible label_environment_dev -m ping
```

Run the test playbook:

```bash
ansible-playbook test-playbook.yml          # all hosts
ansible-playbook -l multipass test-playbook.yml
ansible-playbook -l label_environment_dev test-playbook.yml
```

---

## 4. Interactive Access

### Hetzner

```bash
ssh -l ubuntu "$(hcloud server ip dev-node-1)"
ssh -l ubuntu "$(hcloud server ip dev-node-2)"
ssh -l ubuntu "$(hcloud server ip dev-node-3)"
```

### Multipass

Use `multipass shell` (no need to track IPs):

```bash
multipass shell node-1
multipass shell node-2
```

Or list and choose:

```bash
multipass list
multipass shell <name>
```

---

## 5. Cleanup

Hetzner:

```bash
tofu destroy --auto-approve
```

Multipass:

```bash
multipass delete --all -p
```

---

**Notes**

* Kubernetes minor is controlled via `kubernetes_version` (Terraform var + template placeholder).
* SSH is pubkey-only; ensure the key injected via `cloud-init.tftpl` matches your local key.
* One cloud-init template (`cloud-init.tftpl`) drives both Hetzner and Multipass for consistent nodes.

