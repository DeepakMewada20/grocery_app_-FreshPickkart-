#!/bin/bash

# Production Domain
DOMAIN="freshpickkart.com"

echo "🌐 Using Production Domain: $DOMAIN"
echo "🚀 Running Admin App with --dart-define=ADMIN_API_BASE_URL=https://$DOMAIN/api/"
echo ""

# Run the app
flutter run --dart-define=ADMIN_API_BASE_URL=https://$DOMAIN/api/
