#!/usr/bin/env bash
set -euo pipefail

# ---------- configurable knobs ----------
NODES="${1:-2}"                     # default: 2 nodes
NAME_PREFIX="node"
MEMORY="4G"
DISK="20G"
CPUS="2"
IMAGE="24.04"                       # Ubuntu 24.04

CLOUD_INIT_TEMPLATE="cloud-init.tftpl"
SSH_KEY_FILE="${SSH_KEY_FILE:-$HOME/.ssh/id_rsa.pub}"
K8S_VERSION="${K8S_VERSION:-1.34}"  # matches your Terraform default
# ---------------------------------------

if [[ ! -f "$CLOUD_INIT_TEMPLATE" ]]; then
  echo "Template '$CLOUD_INIT_TEMPLATE' not found" >&2
  exit 1
fi

if [[ ! -f "$SSH_KEY_FILE" ]]; then
  echo "SSH key file '$SSH_KEY_FILE' not found" >&2
  exit 1
fi

# Read the SSH public key (single line)
SSH_KEY="$(cat "$SSH_KEY_FILE")"

# Prepare a temp cloud-init file by substituting ${ssh_key} and ${kubernetes_version}
TMP_CLOUD_INIT="$(mktemp)"
trap 'rm -f "$TMP_CLOUD_INIT"' EXIT

export ssh_key="$SSH_KEY"
export kubernetes_version="$K8S_VERSION"

# envsubst will replace ${ssh_key} and ${kubernetes_version} in the template
envsubst < "$CLOUD_INIT_TEMPLATE" > "$TMP_CLOUD_INIT"

echo "Using Kubernetes version: $K8S_VERSION"
echo "Using SSH key from:       $SSH_KEY_FILE"
echo "Rendered cloud-init:      $TMP_CLOUD_INIT"
echo

# Launch VMs
for i in $(seq 1 "$NODES"); do
  NAME="${NAME_PREFIX}-${i}"

  echo "Launching ${NAME}..."
  multipass launch \
    --name "${NAME}" \
    --memory "${MEMORY}" \
    --disk "${DISK}" \
    --cpus "${CPUS}" \
    --cloud-init "$TMP_CLOUD_INIT" \
    "${IMAGE}"
done

echo
echo "Cluster VMs:"
multipass list

