import Foundation
import Shared
@_exported import YouTubeKit

struct YouTubeKitClient {
    var extractVideoURL: @Sendable (String) async throws -> URL
    var extractHighestQualityVideoURL: @Sendable (String) async throws -> URL
    var extractAudioOnlyURL: @Sendable (String) async throws -> URL
    var extractStreamInfo: @Sendable (String) async throws -> StreamInfo
}

struct StreamInfo: Equatable, Sendable {
    let url: URL
    let quality: String
    let fileExtension: String
    let hasAudio: Bool
    let hasVideo: Bool
}

extension YouTubeKitClient: TestDependencyKey {
    static let testValue = YouTubeKitClient(
        extractVideoURL: unimplemented("YouTubeKitClient.extractVideoURL"),
        extractHighestQualityVideoURL: unimplemented("YouTubeKitClient.extractHighestQualityVideoURL"),
        extractAudioOnlyURL: unimplemented("YouTubeKitClient.extractAudioOnlyURL"),
        extractStreamInfo: unimplemented("YouTubeKitClient.extractStreamInfo")
    )
    
    static let previewValue = YouTubeKitClient(
        extractVideoURL: { _ in
            URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        },
        extractHighestQualityVideoURL: { _ in
            URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        },
        extractAudioOnlyURL: { _ in
            URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!
        },
        extractStreamInfo: { _ in
            StreamInfo(
                url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
                quality: "1080p",
                fileExtension: "mp4",
                hasAudio: true,
                hasVideo: true
            )
        }
    )
}

extension YouTubeKitClient: DependencyKey {
    static let liveValue = YouTubeKitClient(
        extractVideoURL: { videoIDOrURL in
            let youtube: YouTube
            
            // Handle both video ID and full URL
            if videoIDOrURL.contains("youtube.com") || videoIDOrURL.contains("youtu.be") {
                youtube = YouTube(url: URL(string: videoIDOrURL)!)
            } else {
                youtube = YouTube(videoID: videoIDOrURL)
            }
            
            // Try local extraction first, fall back to remote if needed
            let streams = try await youtube.streams
            
            // Get streams that are natively playable and include both video and audio
            guard let stream = streams
                .filter({ $0.isNativelyPlayable && $0.includesVideoAndAudioTrack })
                .highestResolutionStream()
            else {
                throw YouTubeKitError.noSuitableStreamFound
            }
            
            return stream.url
        },
        extractHighestQualityVideoURL: { videoIDOrURL in
            let youtube: YouTube
            
            if videoIDOrURL.contains("youtube.com") || videoIDOrURL.contains("youtu.be") {
                youtube = YouTube(url: URL(string: videoIDOrURL)!)
            } else {
                youtube = YouTube(videoID: videoIDOrURL)
            }
            
            let streams = try await youtube.streams
            
            // Get highest resolution stream with both video and audio
            guard let stream = streams
                .filter({ $0.includesVideoAndAudioTrack && $0.isNativelyPlayable })
                .highestResolutionStream()
            else {
                throw YouTubeKitError.noSuitableStreamFound
            }
            
            return stream.url
        },
        extractAudioOnlyURL: { videoIDOrURL in
            let youtube: YouTube
            
            if videoIDOrURL.contains("youtube.com") || videoIDOrURL.contains("youtu.be") {
                youtube = YouTube(url: URL(string: videoIDOrURL)!)
            } else {
                youtube = YouTube(videoID: videoIDOrURL)
            }
            
            let streams = try await youtube.streams
            
            // Get highest quality audio-only stream
            guard let stream = streams
                .filterAudioOnly()
                .filter({ $0.fileExtension == .m4a })
                .highestAudioBitrateStream()
            else {
                throw YouTubeKitError.noSuitableStreamFound
            }
            
            return stream.url
        },
        extractStreamInfo: { videoIDOrURL in
            let youtube: YouTube
            
            if videoIDOrURL.contains("youtube.com") || videoIDOrURL.contains("youtu.be") {
                youtube = YouTube(url: URL(string: videoIDOrURL)!)
            } else {
                youtube = YouTube(videoID: videoIDOrURL)
            }
            
            let streams = try await youtube.streams
            
            guard let stream = streams
                .filter({ $0.isNativelyPlayable && $0.includesVideoAndAudioTrack })
                .highestResolutionStream()
            else {
                throw YouTubeKitError.noSuitableStreamFound
            }
            
            return StreamInfo(
                url: stream.url,
                quality: stream.videoResolution?.description ?? "Unknown",
                fileExtension: stream.fileExtension.rawValue,
                hasAudio: stream.includesAudioTrack,
                hasVideo: stream.includesVideoTrack
            )
        }
    )
}

extension DependencyValues {
    var youTubeKitClient: YouTubeKitClient {
        get { self[YouTubeKitClient.self] }
        set { self[YouTubeKitClient.self] = newValue }
    }
}

enum YouTubeKitError: LocalizedError {
    case noSuitableStreamFound
    case invalidURL
    case extractionFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .noSuitableStreamFound:
            return "No suitable stream found for playback"
        case .invalidURL:
            return "Invalid YouTube URL or video ID"
        case .extractionFailed(let message):
            return "Failed to extract video: \(message)"
        }
    }
}

