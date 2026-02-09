#!/usr/bin/env bash
set -euo pipefail

export RUNTIME_SERVICE="kafka"
bash ../_shared/deploy-runtime.sh
