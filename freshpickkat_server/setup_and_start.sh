#!/usr/bin/env zsh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if ! grep -q '^GOOGLE_MAPS_API_KEY=' "$ENV_FILE" 2>/dev/null; then
  echo -n "Enter GOOGLE_MAPS_API_KEY: "
  read -rs key
  echo
  echo "GOOGLE_MAPS_API_KEY=\"$key\"" >> "$ENV_FILE"
  chmod 600 "$ENV_FILE"
  echo "Added GOOGLE_MAPS_API_KEY to .env"
else
  echo "GOOGLE_MAPS_API_KEY already present in .env"
  chmod 600 "$ENV_FILE"
fi

echo "Secrets ready. Run your app manually."
