# Build Setup Guide

This guide explains how to set up the build environment for NativeYoutube with code signing, notarization, and Sparkle auto-update support.

## Prerequisites

1. macOS with Xcode installed
2. Apple Developer account with Developer ID certificate
3. GitHub account with a personal access token

## Configuration

### 1. Certificate Setup

Your certificate password is: `abc`
Your team ID is: `9RPB76Y973`
Your Apple ID is: `aayushpokharel9029@gmail.com`
Your app-specific password is: `dhfx-fhra-srvf-eirj`

### 2. GitHub Secrets

Run the setup script to prepare your GitHub secrets:

```bash
./scripts/setup_github_secrets.sh path/to/your/certificate.p12
```

Add these secrets to your repository at Settings > Secrets and variables > Actions:

1. `SIGNING_CERTIFICATE_BASE64` - Base64 encoded certificate
2. `SIGNING_CERTIFICATE_PASSWORD` - Certificate password (abc)
3. `DEVELOPMENT_TEAM` - Apple Developer Team ID (9RPB76Y973)
4. `APPLE_ID` - Apple ID email (aayushpokharel9029@gmail.com)
5. `APPLE_ID_PASSWORD` - App-specific password (dhfx-fhra-srvf-eirj)
6. `SPARKLE_PRIVATE_KEY` - Base64 encoded Sparkle private key
7. `GH_TOKEN` - GitHub personal access token with repo permissions

### 3. Local Build

For local builds, run:

```bash
./scripts/build_and_sign.sh
```

The script will use the configured values to:
- Build the app
- Code sign it
- Notarize it with Apple
- Create a distribution ZIP
- Sign the update with Sparkle

### 4. CI/CD Build

The GitHub Actions workflow will automatically:
1. Build and sign the app when you push a version tag (e.g., `v1.0.0`)
2. Notarize the app with Apple
3. Create a DMG and ZIP for distribution
4. Sign the update with Sparkle
5. Create a GitHub release
6. Update the appcast.xml file

To trigger a release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

### 5. Environment Variables

You can override configuration by setting environment variables:

```bash
export DEVELOPMENT_TEAM=your_team_id
export APPLE_ID=your_apple_id
export APP_SPECIFIC_PASSWORD=your_app_password
./scripts/build_and_sign.sh
```

## Security Notes

⚠️ **IMPORTANT**: Before committing:
1. Remove all sensitive values from scripts
2. Never commit your certificate file
3. Never commit your private keys
4. Use GitHub secrets for all sensitive data

## Troubleshooting

1. **Certificate not found**: Make sure the certificate path is correct
2. **Notarization fails**: Check your Apple ID and app-specific password
3. **Code signing fails**: Verify your team ID and certificate name
4. **Sparkle signing fails**: Ensure the private key path is correct

For more details, see the [Sparkle Setup Guide](SPARKLE_SETUP.md).