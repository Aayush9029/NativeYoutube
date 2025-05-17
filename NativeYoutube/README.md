# NativeYoutube App

This is the main application target for NativeYoutube, a macOS menu bar app for managing YouTube playlists and videos.

## Architecture

The app follows a coordinator pattern similar to ComposeApp:

- **AppCoordinator**: Manages all app state and navigation
- **Views**: Pure presentation layers that display state and handle user interaction
- **Dependencies**: All business logic is extracted into dependency clients

## Key Components

### AppCoordinator

The central coordinator that manages:
- Page navigation
- Search functionality and results
- Playlist loading and management
- Video playback actions
- App-wide state

### Views

All views use `@EnvironmentObject` to access the coordinator:
- `ContentView`: Main container with navigation
- `SearchVideosView`: Displays search UI and results
- `PlayListView`: Shows playlist videos
- `PreferencesView`: App settings

### State Management

The app uses:
- `@Published` properties in AppCoordinator for app state
- `@Shared` from Sharing package for persistent state
- `@Dependency` for dependency injection

## Search Flow

1. User enters search query in BottomBarView
2. ContentView calls `coordinator.search(query)`
3. AppCoordinator updates search status and fetches results
4. SearchVideosView displays results based on coordinator state
5. User taps video -> coordinator handles playback action

## Playlist Flow

1. PlayListView appears and calls `loadPlaylist()`
2. Fetches videos using playlistClient
3. Updates coordinator's playlistVideos
4. Displays videos in VideoListView
5. User taps video -> coordinator handles playback action