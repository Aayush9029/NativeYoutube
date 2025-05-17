# Sparkle Setup Instructions

Follow these steps to complete the Sparkle integration in Xcode:

## 1. Add Sparkle Package Dependency

1. Open `NativeYoutube.xcodeproj` in Xcode
2. Select the project in the navigator
3. Select the "NativeYoutube" target
4. Go to the "General" tab
5. Scroll to "Frameworks, Libraries, and Embedded Content"
6. Click the "+" button
7. Click "Add Package Dependency..."
8. Enter: `https://github.com/sparkle-project/Sparkle`
9. Choose "Up to Next Major Version" with minimum version 2.0.0
10. Click "Add Package"
11. Select "Sparkle" from the package products
12. Click "Add Package"

## 2. Import Sparkle in Code

The code changes have already been made:
- `AppCoordinator.swift` now imports Sparkle and manages updates
- `GeneralPreferenceView.swift` includes update preferences
- `NativeYoutubeApp.swift` includes a menu item for checking updates

## 3. Configure Info.plist

The following keys have been added to `Info.plist`:
- `SUFeedURL`: Points to the appcast.xml file on GitHub
- `SUPublicEDKey`: Contains the public key for signature verification

## 4. Set Up GitHub Repository

1. Create these repository secrets in Settings > Secrets and variables > Actions:
   - `SIGNING_CERTIFICATE_BASE64`: Your Developer ID certificate in base64
   - `SIGNING_CERTIFICATE_PASSWORD`: Certificate password
   - `DEVELOPMENT_TEAM`: Your Apple Developer Team ID
   - `APPLE_ID`: Apple ID for notarization
   - `APPLE_ID_PASSWORD`: App-specific password for notarization

2. (Optional) Add the private key if you want GitHub to sign updates:
   - `SPARKLE_PRIVATE_KEY`: Base64 encoded dsa_priv.pem

Run `./scripts/setup_github_secrets.sh` for help with these values.

## 5. Test the Setup

1. Build and run the app
2. Check the "Native Youtube" menu for "Check for Updates..."
3. Open Preferences and verify the update settings
4. The app will automatically check for updates based on your preferences

## 6. Create Your First Release

1. Update your app version in Xcode (both CFBundleShortVersionString and CFBundleVersion)
2. Commit and push your changes
3. Create a tag: `git tag v1.0.0`
4. Push the tag: `git push origin v1.0.0`
5. GitHub Actions will automatically:
   - Build the app
   - Create a DMG
   - Create a ZIP for Sparkle
   - Sign the update
   - Update appcast.xml
   - Create a GitHub release

## Security Notes

- The private key (`sparkle/dsa_priv.pem`) is in .gitignore and should NEVER be committed
- Keep this key secure - it's used to sign your updates
- The public key is embedded in the app and verifies update signatures
- Apple notarization ensures your app is safe to run on macOS

## Troubleshooting

If updates aren't working:
1. Check that the feed URL in Info.plist is correct
2. Verify the public key matches your private key
3. Ensure appcast.xml is accessible at the feed URL
4. Check that signatures are being generated correctly
5. Look for errors in Console.app

For more details, see the [Sparkle documentation](https://sparkle-project.org/documentation/).