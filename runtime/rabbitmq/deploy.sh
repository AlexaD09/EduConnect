#!/usr/bin/env bash
set -euo pipefail

export RUNTIME_SERVICE="rabbitmq"
bash ../_shared/deploy-runtime.sh
