# NativeYoutube

NativeYoutube is a menu bar YouTube client for macOS 14 and later. It uses SwiftUI, the Point-Free libraries (Dependencies, Sharing, SwiftUINavigation, IdentifiedCollections), YouTubeKit, and Sparkle. The app is free, and a Gumroad license removes the reminders. Status: shipped, with releases through GitHub Releases, a Sparkle feed, and the Homebrew cask `aayush9029/tap/nativeyoutube`.

## Commands

| Task | Command |
|------|---------|
| Build the app | `xcodebuild -scheme NativeYoutube -destination 'platform=macOS' build` |
| Test the package | `cd NativeYoutubeKit && swift test` |
| Find unused code | `periphery scan` (reads `.periphery.yml`) |

## Architecture

| Part | Path | Role |
|------|------|------|
| App target | `NativeYoutube/` | App entry, `AppCoordinator`, menu bar views, window and app-state clients |
| Licensing | `NativeYoutube/License/` | Gumroad license check, activation view, reminder view |
| NativeYoutubeKit | `NativeYoutubeKit/` | Local SPM package: `UI`, `Assets`, `Models`, `APIClient`, `Shared`, `Clients` |
| Landing page | `docs/index.html` | Static product page |

- `APIClient` calls the YouTube Data API. The user enters the API key in the app settings.
- `YouTubeKitClient` gets the stream URLs for playback.
- Put new logic in `NativeYoutubeKit` with a `@Dependency` client, so the tests can replace it.

## Tests

- `APIIntegrationTests` call the real YouTube API. They read `YOUTUBE_API_KEY` from the environment or from the gitignored `.env` at the repository root. Do not commit `.env`.
- The other test targets (`APIClientTests`, `ClientsTests`, `ModelsTests`) run offline.

## Release

1. Set `MARKETING_VERSION` in the project to the new version.
2. Publish a GitHub release with the tag `v<version>`.
3. The `build-and-release.yml` workflow checks that the tag matches `MARKETING_VERSION`, then builds, signs, notarizes, makes the DMG, writes the Sparkle `appcast.xml`, and uploads both to Backblaze B2.
4. Update the cask in `../../homebrew-tap/Casks/nativeyoutube.rb`.

- The workflow secrets are `APPLE_CERTIFICATE_P12`, `APPLE_CERTIFICATE_PASSWORD`, `APPLE_API_KEY_P8`, `APPLE_API_KEY_ID`, `APPLE_API_ISSUER_ID`, `APPLE_TEAM_ID`, `SPARKLE_PRIVATE_KEY`, `B2_APPLICATION_KEY_ID`, `B2_APPLICATION_KEY`, and `B2_BUCKET_NAME`.
- CI requires Xcode 26 on `macos-26`.
