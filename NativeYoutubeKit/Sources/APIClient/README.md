# APIClient

The APIClient is responsible for all YouTube API interactions in NativeYoutube.

## Architecture

The APIClient follows a clean, modular architecture:

1. **Protocol-based Requests**: All requests implement `YouTubeAPIRequest` protocol
2. **Type-safe Endpoints**: `YouTubeEndpoint` enum handles URL construction
3. **Generic Request Handler**: `performRequest<T>` handles all network operations
4. **Error Handling**: Comprehensive `APIError` enum with localized descriptions

## Key Components

### APIClient
Main client with two methods:
- `searchVideos`: Search for YouTube videos
- `fetchPlaylistVideos`: Fetch videos from a playlist

### Request Types
- `SearchRequest`: Contains search query and parameters
- `PlaylistRequest`: Contains playlist ID and parameters

### YouTubeEndpoint
Private enum that:
- Constructs proper URLs using URLQueryItem
- Handles different endpoint paths
- Ensures type safety for API calls

### Error Handling
`APIError` enum provides:
- Clear error cases
- Localized error descriptions
- Type-safe error handling

## Benefits of Refactoring

1. **DRY Principle**: Eliminated duplicate code between search and playlist methods
2. **Type Safety**: Strong typing with protocols and generics
3. **Maintainability**: Easy to add new endpoints
4. **Testability**: Clear separation of concerns
5. **URL Construction**: Proper URL encoding with URLComponents

## Usage Example

```swift
let client = APIClient.live()

// Search videos
let searchRequest = SearchRequest(query: "Swift", apiKey: apiKey)
let videos = try await client.searchVideos(searchRequest)

// Fetch playlist
let playlistRequest = PlaylistRequest(playlistId: "PLxxxx", apiKey: apiKey)
let playlistVideos = try await client.fetchPlaylistVideos(playlistRequest)
```