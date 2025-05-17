#!/bin/bash

# Test script to verify your build setup
set -e

echo "Testing NativeYoutube Build Setup"
echo "================================"
echo

# Check for required tools
echo "Checking required tools..."
command -v xcodebuild >/dev/null || { echo "❌ Xcode command line tools not found"; exit 1; }
command -v notarytool >/dev/null || { echo "❌ notarytool not found"; exit 1; }
echo "✅ Required tools found"
echo

# Check certificate
echo "Checking certificate..."
if security find-identity -p codesigning | grep -q "Developer ID Application"; then
    echo "✅ Developer ID certificate found"
else
    echo "❌ Developer ID certificate not found"
    echo "   Run: security find-identity -p codesigning"
    exit 1
fi
echo

# Check Sparkle keys
echo "Checking Sparkle keys..."
if [ -f "sparkle-keys/sparkle/dsa_priv.pem" ]; then
    echo "✅ Sparkle private key found"
else
    echo "❌ Sparkle private key not found at sparkle-keys/sparkle/dsa_priv.pem"
fi

if [ -f "sparkle-keys/sparkle/dsa_pub.pem" ]; then
    echo "✅ Sparkle public key found"
else
    echo "❌ Sparkle public key not found at sparkle-keys/sparkle/dsa_pub.pem"
fi
echo

# Check environment
echo "Current configuration:"
echo "====================="
echo "Team ID: ${DEVELOPMENT_TEAM:-9RPB76Y973}"
echo "Apple ID: ${APPLE_ID:-aayushpokharel9029@gmail.com}"
echo

# Test build (dry run)
echo "Testing build configuration..."
xcodebuild -project NativeYoutube.xcodeproj \
    -scheme NativeYoutube \
    -configuration Release \
    -showBuildSettings | grep -E "(DEVELOPMENT_TEAM|CODE_SIGN)" || true
echo

echo "Setup test complete!"
echo
echo "To run a full build test:"
echo "  ./scripts/build_and_sign.sh"
echo
echo "To set up GitHub secrets:"
echo "  ./scripts/setup_github_secrets.sh /path/to/certificate.p12"