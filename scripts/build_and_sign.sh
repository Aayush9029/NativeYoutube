#!/bin/bash

# Exit on error
set -e

# Configuration
PROJECT_NAME="NativeYoutube"
CONFIGURATION="Release"
SCHEME="NativeYoutube"
BUILD_DIR="build"
DIST_DIR="dist"
VERSION=$(defaults read "$PWD/$PROJECT_NAME/Info.plist" CFBundleShortVersionString)
BUILD_NUMBER=$(defaults read "$PWD/$PROJECT_NAME/Info.plist" CFBundleVersion)
ARCHIVE_NAME="$PROJECT_NAME-$VERSION"

# Code signing configuration (can be overridden by environment variables)
DEVELOPMENT_TEAM="${DEVELOPMENT_TEAM:-9RPB76Y973}"
APPLE_ID="${APPLE_ID:-aayushpokharel9029@gmail.com}"
APP_SPECIFIC_PASSWORD="${APP_SPECIFIC_PASSWORD:-dhfx-fhra-srvf-eirj}"
CERTIFICATE_NAME="${CERTIFICATE_NAME:-Developer ID Application}"

echo "Building $PROJECT_NAME version $VERSION ($BUILD_NUMBER)..."
echo "Team ID: $DEVELOPMENT_TEAM"

# Clean previous builds
rm -rf "$BUILD_DIR"
rm -rf "$DIST_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$DIST_DIR"

# Import certificate if running in CI
if [ ! -z "$SIGNING_CERTIFICATE_BASE64" ]; then
    echo "Importing certificate from CI environment..."
    echo "$SIGNING_CERTIFICATE_BASE64" | base64 --decode > certificate.p12
    
    # Create keychain
    KEYCHAIN_NAME="build.keychain"
    KEYCHAIN_PASSWORD="temp_password_$(date +%s)"
    security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_NAME"
    security set-keychain-settings -lut 21600 "$KEYCHAIN_NAME"
    security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_NAME"
    
    # Import certificate
    security import certificate.p12 -P "$SIGNING_CERTIFICATE_PASSWORD" -A -t cert -f pkcs12 -k "$KEYCHAIN_NAME"
    security list-keychain -d user -s "$KEYCHAIN_NAME"
    security set-key-partition-list -S apple-tool:,apple: -s -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN_NAME"
fi

# Archive the project
echo "Creating archive..."
xcodebuild -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$BUILD_DIR/$PROJECT_NAME.xcarchive" \
    -allowProvisioningUpdates \
    DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM" \
    CODE_SIGN_STYLE=Automatic \
    archive

# Export the archive
echo "Exporting archive..."
cat > "$BUILD_DIR/ExportOptions.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>developer-id</string>
    <key>teamID</key>
    <string>$DEVELOPMENT_TEAM</string>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
EOF

xcodebuild -exportArchive \
    -archivePath "$BUILD_DIR/$PROJECT_NAME.xcarchive" \
    -exportOptionsPlist "$BUILD_DIR/ExportOptions.plist" \
    -exportPath "$DIST_DIR" \
    -allowProvisioningUpdates

# Notarize the app
echo "Notarizing the app..."
APP_PATH="$DIST_DIR/$PROJECT_NAME.app"

# Create ZIP for notarization
ditto -c -k --keepParent "$APP_PATH" "$DIST_DIR/$ARCHIVE_NAME-notarize.zip"

# Submit for notarization
echo "Submitting for notarization..."
NOTARIZE_RESPONSE=$(xcrun notarytool submit "$DIST_DIR/$ARCHIVE_NAME-notarize.zip" \
    --apple-id "$APPLE_ID" \
    --password "$APP_SPECIFIC_PASSWORD" \
    --team-id "$DEVELOPMENT_TEAM" \
    --wait --output-format plist)

# Check notarization status
NOTARIZE_STATUS=$(echo "$NOTARIZE_RESPONSE" | plutil -extract status raw -)
if [ "$NOTARIZE_STATUS" = "Accepted" ]; then
    echo "Notarization successful!"
    
    # Staple the notarization ticket
    xcrun stapler staple "$APP_PATH"
    echo "Notarization ticket stapled to app"
else
    echo "Notarization failed with status: $NOTARIZE_STATUS"
    echo "$NOTARIZE_RESPONSE"
    exit 1
fi

# Create distribution ZIP
echo "Creating final distribution ZIP..."
cd "$DIST_DIR"
ditto -c -k --keepParent "$PROJECT_NAME.app" "$ARCHIVE_NAME.zip"
cd ..

# Sign the update with Sparkle
if [ -f "sparkle-keys/sparkle/dsa_priv.pem" ] || [ ! -z "$SPARKLE_PRIVATE_KEY" ]; then
    echo "Signing update with Sparkle..."
    
    # If private key is provided as base64 in CI
    if [ ! -z "$SPARKLE_PRIVATE_KEY" ]; then
        echo "$SPARKLE_PRIVATE_KEY" | base64 --decode > sparkle_temp_key.pem
        SPARKLE_KEY_PATH="sparkle_temp_key.pem"
    else
        SPARKLE_KEY_PATH="sparkle-keys/sparkle/dsa_priv.pem"
    fi
    
    # Download Sparkle tools if not present
    if [ ! -f "./bin/generate_appcast" ]; then
        echo "Downloading Sparkle tools..."
        mkdir -p bin
        curl -L https://github.com/sparkle-project/Sparkle/releases/latest/download/Sparkle-2.x.tar.xz | tar xJ -C bin --strip-components=2 Sparkle.framework/Versions/Current/Resources/
    fi
    
    # Generate appcast entry
    ./bin/generate_appcast sparkle --download-url-prefix "https://github.com/YOUR_USERNAME/YOUR_REPO/releases/download/v$VERSION/"
    
    # Clean up temp key if used
    if [ -f "sparkle_temp_key.pem" ]; then
        rm "sparkle_temp_key.pem"
    fi
else
    echo "Warning: Sparkle private key not found. Update signature will need to be added manually."
fi

# Clean up certificates from CI
if [ ! -z "$SIGNING_CERTIFICATE_BASE64" ]; then
    rm -f certificate.p12
    security delete-keychain "$KEYCHAIN_NAME"
fi

echo "Build complete!"
echo "Archive created at: $DIST_DIR/$ARCHIVE_NAME.zip"
echo "App bundle: $DIST_DIR/$PROJECT_NAME.app"
echo ""
echo "Next steps:"
echo "1. Upload $DIST_DIR/$ARCHIVE_NAME.zip to GitHub releases"
echo "2. Update sparkle/appcast.xml with the new release"
echo "3. Commit and push the updated appcast.xml"