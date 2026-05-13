#!/bin/bash

# Remote AWS IP Address
REMOTE_IP="144.217.241.119"

echo "🌐 Using Remote Production IP: $REMOTE_IP"
echo "🚀 Running User App with --dart-define=API_BASE_URL=http://$REMOTE_IP/api/"
echo ""

# Run the app
flutter run --dart-define=API_BASE_URL=http://$REMOTE_IP/api/
