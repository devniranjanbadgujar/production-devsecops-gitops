#!/usr/bin/env bash
set -euo pipefail

VALUES_FILE="${1:-apps/production-devsecops-platform/values-ecr.yaml}"

if [[ ! -f "$VALUES_FILE" ]]; then
  echo "ERROR: Values file not found: $VALUES_FILE" >&2
  exit 1
fi

if grep -Eq \
  '^[[:space:]]*image:[[:space:]]*ACCOUNT_ID\.dkr\.ecr\.|^[[:space:]]*tag:[[:space:]]*"BUILD_NUMBER"$' \
  "$VALUES_FILE"; then
  echo "ERROR: ECR image values still contain placeholders." >&2
  exit 1
fi

echo "Image values passed placeholder validation."
