# NativeYoutube Changelog

## v3.0.0 - Major Architecture Refactoring

### ✨ Highlights

This major release marks a complete architectural overhaul of NativeYoutube, transitioning from a traditional MVVM pattern to a modern modular architecture. The app has been restructured to use the Composable Architecture pattern with proper dependency injection and module separation.

### 🏗️ Architecture Changes

- **Introduced AppCoordinator Pattern**: Centralized navigation and state management through a new `AppCoordinator` class
- **Migrated to Package-based Architecture**: Created `NativeYoutubeKit` Swift Package with modular components:
  - `APIClient`: Centralized API communication
  - `Clients`: Dependency injection for various services
  - `UI`: Shared UI components
  - `Models`: Domain models
  - `Shared`: Common utilities
  - `Assets`: Resource management

### 🚀 Major Features

- **Floating Window Support**: New floating video player capability with dedicated `FloatingWindowClient`
- **Enhanced Dependencies**: Upgraded to modern dependencies using Point-Free's ecosystem:
  - `swift-dependencies` for dependency injection
  - `swift-sharing` for shared state management
  - `swift-identified-collections` for collection handling
- **YouTubeKit Integration**: Native YouTube API integration for improved performance
- **Improved Testing Infrastructure**: Added comprehensive test suite with mock responses

### 🔄 API & Networking

- Removed legacy `PlaylistsRequest` and `SearchRequest` classes
- Implemented new client-based architecture:
  - `SearchClient` for video search functionality
  - `PlaylistClient` for playlist management
  - `YouTubeKitClient` for YouTube API integration
  - `AppStateClient` for app state management

### 🎨 UI Enhancements

- **New Components**:
  - `YouTubePlayerView`: Dedicated video player view
  - `VideoContextMenuView`: Enhanced context menu for videos
  - `VideoListView` & `VideoRowView`: Improved video listing
  - `BottomBarView`: New bottom navigation bar
  - `CleanButton`: Reusable button component
  - `WelcomeView`: Onboarding experience
  - `GlowEffect` & `GlowEffectViewModifier`: Visual effects
- **Removed Legacy Views**: Cleaned up old view extensions and NSViewRepresentable extensions

### 📦 Dependency Management

- Migrated from individual dependencies to Swift Package Manager
- Updated dependency versions:
  - `swift-dependencies`: 1.7.0+
  - `swift-sharing`: 2.4.0+
  - `YouTubeKit`: 0.2.7+

### 🛠️ Developer Experience

- Added `.periphery.yml` for code analysis
- Enhanced GitHub Actions workflow (`.github/workflows/swift.yml`)
- Added comprehensive test suite with mock responses
- Created `RunTests.swift` for automated testing
- Added Claude AI integration settings (`.claude/settings.local.json`)

### 🔐 Permissions & Security

- Enhanced entitlements management
- Improved API key handling through `Sharing+Keys.swift`
- Secure credential storage using keychain

### 🐛 Bug Fixes

- Fixed build errors with updated Xcode configuration
- Resolved window management issues
- Fixed error handling in API calls
- Improved error logging and debugging

### ⚡ Performance Improvements

- Optimized view models lifecycle
- Better memory management with proper dependency injection
- Reduced app bundle size through modularization
- Improved search and playlist loading performance

### 🚨 Breaking Changes

- Complete removal of legacy view models:
  - `AppStateViewModel`
  - `PlayListViewModel`
  - `SearchViewModel`
  - `YoutubePreferenceViewModel`
- Changed from delegate pattern to coordinator pattern
- Restructured preferences to use shared state
- Modified video click behavior handling

### 📝 Notes

This release represents a complete rewrite of the app's architecture. While maintaining the same user-facing features, the underlying structure has been modernized to be more maintainable, testable, and performant. The transition to a package-based architecture allows for better code organization and reusability.

### 🔮 Future Roadmap

The v3 architecture sets the foundation for:
- Multi-window support
- Enhanced video playback features
- Improved caching mechanisms
- Better offline support
- Cross-platform capabilities

---

**Contributors**: Thank you to all contributors who made this major release possible!

**Migration Guide**: For developers upgrading from v2, please refer to the migration documentation in the wiki.