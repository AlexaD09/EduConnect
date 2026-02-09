#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${RUNTIME_SERVICE:-}" ]]; then
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RUNTIME_DIR="$ROOT_DIR/runtime"
SERVICE_DIR="$RUNTIME_DIR/$RUNTIME_SERVICE"

if [[ ! -d "$SERVICE_DIR" ]]; then
  exit 1
fi

if [[ ! -f "$SERVICE_DIR/docker-compose.yml" ]]; then
  exit 1
fi

ENDPOINTS_JSON="$(cd "$ROOT_DIR/infra" && terraform output -json service_endpoints)"
BASTION_IP="$(cd "$ROOT_DIR/infra" && terraform output -raw bastion_public_ip)"

SERVICE_IP="$(python3 - <<PY
import json
d=json.loads("""$ENDPOINTS_JSON""")
print(d["$RUNTIME_SERVICE"]["ip"])
PY
)"

if [[ -z "$SERVICE_IP" ]]; then
  exit 1
fi
 
if [[ -z "$BASTION_IP" ]]; then
  exit 1
fi

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyJump=ec2-user@${BASTION_IP}"

scp $SSH_OPTS -r "$SERVICE_DIR" "ec2-user@${SERVICE_IP}:/home/ec2-user/runtime_${RUNTIME_SERVICE}"

ssh $SSH_OPTS "ec2-user@${SERVICE_IP}" <<EOF
set -euo pipefail
cd "/home/ec2-user/runtime_${RUNTIME_SERVICE}"
sudo docker compose up -d
sudo docker ps
EOF
