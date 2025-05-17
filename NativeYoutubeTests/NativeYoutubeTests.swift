import Testing
import Dependencies
@testable import NativeYoutube
import APIClient
import Clients

@Suite("NativeYoutube Test Suite")
struct NativeYoutubeTests {
    
    @Test("Test dependencies are configured correctly")
    func testDependenciesConfigured() async throws {
        try await withDependencies {
            $0.searchClient = .test
            $0.playlistClient = .test
            $0.apiClient = .test
        } operation: {
            // If we get here, dependencies are configured correctly
            #expect(true)
        }
    }
}