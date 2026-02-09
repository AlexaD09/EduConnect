#!/usr/bin/env bash
set -euo pipefail

export RUNTIME_SERVICE="redis"
bash ../_shared/deploy-runtime.sh
