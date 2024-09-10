# tfstatcks-hetzner

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
```

Interactive Access

```
ssh -l hcloud $(hcloud server ip dev-node-1)
ssh -l hcloud $(hcloud server ip dev-node-2)
ssh -l hcloud $(hcloud server ip dev-node-3)
ssh -l hcloud $(hcloud server ip dev-node-4)
```

Cleanup

```
tofu destroy --auto-approve
```
