#!/usr/bin/env bash
set -euo pipefail

export RUNTIME_SERVICE="postgres"
bash ../_shared/deploy-runtime.sh
 