#!/usr/bin/env bash
set -euo pipefail

# Variables que te dará GH Actions
# - ENDPOINTS_JSON: terraform output -json service_endpoints
# - BASTION_HOST: bastion public ip
# - SSH_USER: ec2-user (o el tuyo)
# - SERVICE_KEY: llave privada ya guardada en ~/.ssh/id_rsa
# - RUNTIME_NAME: "postgres"
# - REMOTE_DIR: "/home/ec2-user/runtime/postgres"

IP=$(echo "$ENDPOINTS_JSON" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['redis']['ip'])")

echo "Deploy runtime redis to $IP via bastion $BASTION_HOST"

REMOTE_DIR_BASE="${REMOTE_DIR_BASE:-/home/ec2-user/runtime}"
REMOTE_DIR="${REMOTE_DIR_BASE}/redis"

ssh -o StrictHostKeyChecking=no -J ${SSH_USER}@${BASTION_HOST} ${SSH_USER}@${IP} "mkdir -p '${REMOTE_DIR}'"

rsync -az -e "ssh -o StrictHostKeyChecking=no -J ${SSH_USER}@${BASTION_HOST}" \
  ./ ${SSH_USER}@${IP}:${REMOTE_DIR}/

ssh -o StrictHostKeyChecking=no -J ${SSH_USER}@${BASTION_HOST} ${SSH_USER}@${IP} << EOF
  set -e
  cd ${REMOTE_DIR}
  docker compose up -d
  docker ps
EOF
