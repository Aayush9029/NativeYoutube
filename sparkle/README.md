# Sparkle Update System Setup

This directory contains the configuration for Sparkle auto-updates.

## Contents

- `dsa_priv.pem` - Private key for signing updates (DO NOT COMMIT!)
- `dsa_pub.pem` - Public key for verifying updates
- `appcast.xml` - Update feed that lists available versions

## Workflow

1. When you create a new release tag (v1.0.0, v1.1.0, etc.) on GitHub:
   - GitHub Actions will automatically build the app
   - Create a DMG for distribution
   - Create a ZIP for Sparkle updates
   - Sign the ZIP with the private key
   - Update the appcast.xml file
   - Create a GitHub release with all files

2. The app checks for updates by:
   - Reading the feed URL from Info.plist
   - Downloading the appcast.xml
   - Verifying signatures with the public key
   - Downloading and installing updates

## Security Setup

### GitHub Secrets Required

Add these secrets to your GitHub repository:

- `SIGNING_CERTIFICATE_BASE64` - Your Apple Developer ID certificate in base64
- `SIGNING_CERTIFICATE_PASSWORD` - Certificate password
- `DEVELOPMENT_TEAM` - Your Apple Developer Team ID
- `APPLE_ID` - Apple ID for notarization
- `APPLE_ID_PASSWORD` - App-specific password for notarization

### Private Key Security

The private key (`dsa_priv.pem`) must be:
1. Stored securely
2. Never committed to the repository
3. Added as a GitHub secret if needed for CI/CD

## Manual Release Process

If you need to create a release manually:

```bash
# Build the app
./scripts/build_and_sign.sh

# Sign the update (requires Sparkle tools)
./bin/sign_update dist/NativeYoutube-1.0.0.zip -f sparkle/dsa_priv.pem

# Update appcast.xml with the new version info
# Upload the ZIP to your release
# Commit the updated appcast.xml
```

## Testing Updates

1. Build a test version with a lower version number
2. Run the app
3. Trigger "Check for Updates" to test the update flow