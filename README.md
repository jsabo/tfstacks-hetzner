# tfstatcks-hetzner

```
tofu init --upgrade
tofu apply --auto-approve
```

```
ansible-inventory -i hcloud.yml --graph
ansible-playbook -i hcloud.yml test-playbook.yml
```

```
ssh -l hcloud $(hcloud server ip dev-node-1)
ssh -l hcloud $(hcloud server ip dev-node-2)
ssh -l hcloud $(hcloud server ip dev-node-3)
```

```
tofu destroy --auto-approve
```
