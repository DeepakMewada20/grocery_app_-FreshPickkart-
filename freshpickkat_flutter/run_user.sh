#!/bin/bash

# Get the local IP address
LOCAL_IP=$(hostname -I | cut -d' ' -f1)

if [ -z "$LOCAL_IP" ]; then
    echo "❌ Could not detect local IP. Please check your network connection."
    exit 1
fi

echo "🚀 Detected Local IP: $LOCAL_IP"
echo "🛠  Running User App with --dart-define=API_BASE_URL=http://$LOCAL_IP:8080/"
echo ""

# Run the app
flutter run --dart-define=API_BASE_URL=http://$LOCAL_IP:8080/
