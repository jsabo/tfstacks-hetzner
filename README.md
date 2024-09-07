# tfstatcks-hetzner


```
tofu init --ugprade
tofo apply --auto-approve

```
ansible-inventory -i hcloud.yml --graph
ansible-playbook -i hcloud.yml setup-k8s.yml
```

```
$ ansible-inventory -i hcloud.yml --graph
@all:
  |--@ungrouped:
  |--@hcloud:
  |  |--dev-node-1
  |  |--dev-node-3
  |  |--dev-node-2
  |--@label_environment_dev:
  |  |--dev-node-1
  |  |--dev-node-3
  |  |--dev-node-2
  |--@type_cpx11:
  |  |--dev-node-1
  |  |--dev-node-3
  |  |--dev-node-2
  |--@location_ash:
  |  |--dev-node-1
  |  |--dev-node-3
  |  |--dev-node-2
  |--@status_running:
  |  |--dev-node-1
  |  |--dev-node-3
  |  |--dev-node-2
```


```
ssh -l root $(hcloud server ip k8s-node-1)
ssh -l root $(hcloud server ip k8s-node-2)
ssh -l root $(hcloud server ip k8s-node-3)
```
