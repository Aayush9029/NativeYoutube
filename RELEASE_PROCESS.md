# Release Process

This document outlines how to create a new release for Native Youtube with automatic building, signing, and Sparkle updates.

## Prerequisites

Ensure the following GitHub secrets are configured:
- `SIGNING_CERTIFICATE_BASE64`: Your Developer ID certificate in base64
- `SIGNING_CERTIFICATE_PASSWORD`: Certificate password
- `DEVELOPMENT_TEAM`: Your Apple Developer Team ID
- `APPLE_ID`: Apple ID for notarization
- `APPLE_ID_PASSWORD`: App-specific password for notarization
- `SPARKLE_PRIVATE_KEY`: Base64 encoded Sparkle private key
- `GH_TOKEN`: GitHub token with workflow permissions

## Release Steps

### Option 1: Using GitHub UI (Recommended)

1. **Update Version Numbers**
   - Update `CFBundleShortVersionString` in `NativeYoutube/Info.plist`
   - Update `CFBundleVersion` in `NativeYoutube/Info.plist`
   - Commit and push these changes

2. **Create a Release Draft**
   - Go to Actions → Create Release Draft workflow
   - Click "Run workflow"
   - Enter the version number (without v prefix)
   - Add a description of changes
   - Click "Run workflow"

3. **Edit and Publish**
   - Go to the Releases page
   - Find your draft release
   - Edit the release notes as needed
   - Click "Publish release"

### Option 2: Using Command Line

1. **Update Version Numbers**
   ```bash
   # Update Info.plist with new version
   # Then commit and push
   git add NativeYoutube/Info.plist
   git commit -m "Bump version to X.Y.Z"
   git push origin main
   ```

2. **Create and Push Tag**
   ```bash
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

3. **Create Release via GitHub CLI**
   ```bash
   gh release create vX.Y.Z \
     --title "Native Youtube vX.Y.Z" \
     --notes "Release notes here..." \
     --draft
   ```

4. **Publish Release**
   ```bash
   gh release edit vX.Y.Z --draft=false
   ```

## What Happens Next

When a release is published, the following automatic process begins:

1. **Build and Sign**
   - Xcode builds the app in Release configuration
   - Code is signed with your Developer ID certificate
   - App is archived and exported

2. **Notarization**
   - App is submitted to Apple for notarization
   - Notarization ticket is stapled to the app

3. **Create Distribution Files**
   - DMG is created for manual installation
   - ZIP is created for Sparkle updates
   - Sparkle signature is generated

4. **Upload Assets**
   - DMG, ZIP, and appcast item are uploaded to the release
   - Files are available for download

5. **Update Appcast**
   - New release entry is added to `sparkle/appcast.xml`
   - Appcast is committed and pushed to main branch
   - Sparkle will detect the update

## Monitoring the Process

1. Go to the Actions tab in GitHub
2. Watch the "Build and Release" workflow
3. Check for any errors or failures
4. Once complete, verify:
   - Release assets are uploaded
   - Appcast.xml is updated in main branch
   - App updates work via Sparkle

## Troubleshooting

### Build Fails
- Check GitHub Actions logs
- Verify all secrets are correctly set
- Ensure certificate hasn't expired

### Notarization Fails
- Check Apple ID credentials
- Verify app-specific password is valid
- Ensure bundle ID matches your Developer ID

### Sparkle Update Not Working
- Verify appcast.xml URL in Info.plist
- Check Sparkle signature generation
- Ensure public key matches private key

### Release Not Triggering Workflow
- Make sure release is published, not draft
- Check workflow permissions
- Verify GH_TOKEN has necessary scopes