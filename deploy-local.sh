#!/bin/bash
set -e

# === CONFIG ===
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

echo ""
echo "=== Builds ready at ==="
echo "  freshpickkat_flutter/build/web/"
echo "  freshpickkat_admin/build/web/"
echo ""
echo "For production deploy: git push origin main:master"
echo "GitHub Actions will handle SCP + Docker restart."
