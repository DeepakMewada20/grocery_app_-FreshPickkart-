#!/bin/bash

# Remote AWS IP Address
REMOTE_IP="144.217.241.119"

echo "🌐 Using Remote Production IP: $REMOTE_IP"
echo "🚀 Running Admin App with --dart-define=ADMIN_API_BASE_URL=http://$REMOTE_IP:8080/"
echo ""

# Run the app
flutter run --dart-define=ADMIN_API_BASE_URL=http://$REMOTE_IP:8080/
