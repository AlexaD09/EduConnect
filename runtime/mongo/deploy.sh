#!/usr/bin/env bash
set -euo pipefail

export RUNTIME_SERVICE="mongo"
bash ../_shared/deploy-runtime.sh
