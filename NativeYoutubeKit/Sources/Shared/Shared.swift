import Dependencies
import Foundation

// Shared module for common utilities and types

@inlinable 
public func withDependencies<R>(
  _ updateValuesForOperation: (inout DependencyValues) -> Void,
  operation: () throws -> R
) rethrows -> R {
  try DependencyValues.$current.withValue {
    updateValuesForOperation(&$0)
    return $0
  } operation: {
    try operation()
  }
}

public enum SharedConstants {
    public static let appName = "NativeYoutube"
    public static let bundleIdentifier = "com.aayush.nativeyoutube"
}

// Extension for async operations
public extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}