#!/bin/bash

# Production Domain
DOMAIN="freshpickkart.com"

echo "🌐 Using Production Domain: $DOMAIN"
echo "🚀 Running User App with --dart-define=API_BASE_URL=https://$DOMAIN/api/"
echo ""

# Run the app
flutter run --dart-define=API_BASE_URL=https://$DOMAIN/api/
