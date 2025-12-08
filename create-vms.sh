#!/usr/bin/env bash
set -euo pipefail

NODES="${1:-2}"            # default: 2 nodes
NAME_PREFIX="node"
MEMORY="4G"
DISK="20G"
CPUS="2"
IMAGE="24.04"              # Ubuntu 24.04

for i in $(seq 1 "$NODES"); do
  NAME="${NAME_PREFIX}-${i}"

  echo "Launching ${NAME}..."
  multipass launch \
    --name "${NAME}" \
    --memory "${MEMORY}" \
    --disk "${DISK}" \
    --cpus "${CPUS}" \
    --cloud-init cloud-init.yml \
    "${IMAGE}"
done

echo
echo "Cluster VMs:"
multipass list

