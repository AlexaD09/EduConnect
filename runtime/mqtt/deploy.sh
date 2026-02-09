#!/usr/bin/env bash
set -euo pipefail

export RUNTIME_SERVICE="mqtt"
bash ../_shared/deploy-runtime.sh
