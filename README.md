# tfstacks-hetzner

Kubernetes lab:

- **Hetzner Cloud** (OpenTofu/Terraform)

---

## Layout

- **Terraform / Hetzner**
  - `main.tf`, `providers.tf`, `variables.tf`, `outputs.tf`
  - `cloud-init.tftpl` – shared cloud-init template
- **Ansible**
  - `ansible.cfg` – uses `hcloud.yml` + `multipass_inventory.py`
  - `hcloud.yml` – Hetzner dynamic inventory
  - `test-playbook.yml` – simple connectivity/privilege check

---

## Prereqs

- OpenTofu/Terraform (`tofu` in examples)
- Ansible + Python 3
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

## 3. Ansible: Inventory & Usage

`ansible.cfg`:

```ini
[defaults]
interpreter_python = auto_silent
inventory = ./hcloud.yml
remote_user = ubuntu
```

So Ansible sees:

* Hetzner hosts via `hcloud.yml` (groups like `label_environment_dev`)

Inspect inventory:

```bash
ansible-inventory --graph
```

Ping everything:

```bash
ansible -m ping all
```

Only Hetzner “dev”:

```bash
ansible label_environment_dev -m ping
```

Run the test playbook:

```bash
ansible-playbook test-playbook.yml          # all hosts
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

---

## 5. Cleanup

Hetzner:

```bash
tofu destroy --auto-approve
```

---

**Notes**

* Kubernetes minor is controlled via `kubernetes_version` (Terraform var + template placeholder).
* SSH is pubkey-only; ensure the key injected via `cloud-init.tftpl` matches your local key.

