#!/usr/bin/env python3
import json
import subprocess
import sys

def main():
    try:
        result = subprocess.run(
            ["multipass", "list", "--format", "json"],
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError:
        # If multipass is not available or errors, return empty inventory
        empty = {"_meta": {"hostvars": {}}, "multipass": {"hosts": []}}
        print(json.dumps(empty))
        sys.exit(0)

    data = json.loads(result.stdout)
    instances = data.get("list", [])

    inventory = {
        "_meta": {"hostvars": {}},
        "multipass": {"hosts": []},
    }

    for inst in instances:
        # Only include running instances
        if inst.get("state") != "Running":
            continue

        name = inst.get("name")
        ipv4 = inst.get("ipv4") or []
        if not name or not ipv4:
            continue

        ip = ipv4[0]

        inventory["multipass"]["hosts"].append(name)
        inventory["_meta"]["hostvars"][name] = {
            "ansible_host": ip,
            "ansible_user": "ubuntu",
        }

    print(json.dumps(inventory))

if __name__ == "__main__":
    main()

