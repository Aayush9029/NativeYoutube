import Foundation

enum TestConfig {
    static var youtubeAPIKey: String? {
        if let envKey = ProcessInfo.processInfo.environment["YOUTUBE_API_KEY"], !envKey.isEmpty {
            return envKey
        }
        return loadFromDotEnv()
    }

    private static func loadFromDotEnv() -> String? {
        // Walk up from the test binary location to find .env at the repo root
        let dir = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // Tests/APIIntegrationTests
            .deletingLastPathComponent() // Tests
            .deletingLastPathComponent() // NativeYoutubeKit
            .deletingLastPathComponent() // repo root

        let envFile = dir.appendingPathComponent(".env")
        guard let contents = try? String(contentsOf: envFile, encoding: .utf8) else {
            return nil
        }

        for line in contents.components(separatedBy: .newlines) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty, !trimmed.hasPrefix("#") else { continue }
            let parts = trimmed.split(separator: "=", maxSplits: 1)
            guard parts.count == 2, parts[0].trimmingCharacters(in: .whitespaces) == "YOUTUBE_API_KEY" else { continue }
            let value = parts[1].trimmingCharacters(in: .whitespaces)
            if !value.isEmpty { return value }
        }

        return nil
    }

    static let defaultPlaylistID = "PLVz-LYNW1HKcil_zzy51Z6ruyNLSJbH7m"
}
