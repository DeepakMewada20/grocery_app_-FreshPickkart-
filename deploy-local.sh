#!/bin/bash
set -e

# === CONFIG ===
SSH_USER="ubuntu"
SSH_HOST="144.217.241.119"
SSH_PORT="22"
SERVER_PROJECT_PATH="~/projects/grocery_app_-FreshPickkart-"
CUSTOMER_API_BASE_URL="https://freshpickkart.com/api/"
ADMIN_API_BASE_URL="https://freshpickkart.com/api/"

# === Build Customer Web ===
echo "=== Building Customer Web ==="
cd freshpickkat_flutter
flutter build web --release \
  --dart-define=API_BASE_URL=$CUSTOMER_API_BASE_URL
cd ..

# === Build Admin Web ===
echo "=== Building Admin Web ==="
cd freshpickkat_admin
flutter build web --release \
  --dart-define=ADMIN_API_BASE_URL=$ADMIN_API_BASE_URL
cd ..

# === Create target directories on server ===
echo "=== Creating target directories on server ==="
ssh -p $SSH_PORT $SSH_USER@$SSH_HOST "
  mkdir -p $SERVER_PROJECT_PATH/freshpickkat_flutter/build/web
  mkdir -p $SERVER_PROJECT_PATH/freshpickkat_admin/build/web
"

# === SCP builds to server ===
echo "=== Copying builds to server ==="
scp -r -P $SSH_PORT freshpickkat_flutter/build/web/* \
  $SSH_USER@$SSH_HOST:$SERVER_PROJECT_PATH/freshpickkat_flutter/build/web/
scp -r -P $SSH_PORT freshpickkat_admin/build/web/* \
  $SSH_USER@$SSH_HOST:$SERVER_PROJECT_PATH/freshpickkat_admin/build/web/

echo "=== Builds delivered to server! ==="
echo "GitHub Actions will build Docker images and restart containers on next push."
