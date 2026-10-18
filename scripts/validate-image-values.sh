#!/usr/bin/env bash
set -euo pipefail

VALUES_FILE="${1:-apps/production-devsecops-platform/values-ecr.yaml}"

if [[ ! -f "$VALUES_FILE" ]]; then
  echo "ERROR: Values file not found: $VALUES_FILE" >&2
  exit 1
fi

if grep -Eq 'ACCOUNT_ID|BUILD_NUMBER' "$VALUES_FILE"; then
  echo "ERROR: ECR image values still contain placeholders." >&2
  echo "Replace ACCOUNT_ID and BUILD_NUMBER before deployment." >&2
  exit 1
fi

echo "Image values passed placeholder validation."
