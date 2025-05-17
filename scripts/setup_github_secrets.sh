#!/bin/bash

# This script helps you prepare the values for GitHub secrets
# DO NOT run this in a public environment or commit the output!

echo "GitHub Secrets Setup Helper"
echo "=========================="
echo

# Configuration values
CERT_PASSWORD="abc"
TEAM_ID="9RPB76Y973"
APPLE_ID="aayushpokharel9029@gmail.com"
APP_SPECIFIC_PASSWORD="dhfx-fhra-srvf-eirj"

# Check if certificate exists
if [ -z "$1" ]; then
    read -p "Enter path to your Developer ID certificate (.p12): " CERT_PATH
else
    CERT_PATH="$1"
fi

if [ ! -f "$CERT_PATH" ]; then
    echo "Error: Certificate not found at $CERT_PATH"
    exit 1
fi

# Convert certificate to base64
echo "Converting certificate to base64..."
CERT_BASE64=$(base64 -i "$CERT_PATH" | tr -d '\n')
echo

echo "Add these secrets to your GitHub repository:"
echo "==========================================="
echo
echo "1. SIGNING_CERTIFICATE_BASE64:"
echo "   $CERT_BASE64"
echo
echo "2. SIGNING_CERTIFICATE_PASSWORD:"
echo "   $CERT_PASSWORD"
echo
echo "3. DEVELOPMENT_TEAM:"
echo "   $TEAM_ID"
echo
echo "4. APPLE_ID:"
echo "   $APPLE_ID"
echo
echo "5. APPLE_ID_PASSWORD:"
echo "   $APP_SPECIFIC_PASSWORD"
echo
echo "6. SPARKLE_PRIVATE_KEY:"
if [ -f "sparkle-keys/sparkle/dsa_priv.pem" ]; then
    PRIVATE_KEY_BASE64=$(base64 -i sparkle-keys/sparkle/dsa_priv.pem | tr -d '\n')
    echo "   $PRIVATE_KEY_BASE64"
else
    echo "   Error: Sparkle private key not found at sparkle-keys/sparkle/dsa_priv.pem"
fi
echo
echo "7. GH_TOKEN:"
echo "   Create a personal access token with 'repo' permissions at:"
echo "   https://github.com/settings/tokens/new"
echo
echo "Remember to add these as repository secrets in:"
echo "Settings > Secrets and variables > Actions"
echo
echo "IMPORTANT: Remove the sensitive values from this script before committing!"