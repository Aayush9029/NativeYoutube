import CustomDump
import Foundation
import Models
import Testing

@Suite("Video Model")
struct VideoTests {
    @Test("Codable round-trip preserves all fields")
    func codableRoundTrip() throws {
        let video = makeVideo()
        let data = try JSONEncoder().encode(video)
        let decoded = try JSONDecoder().decode(Video.self, from: data)
        expectNoDifference(decoded, video)
    }

    @Test("Equatable: identical videos are equal")
    func equatable() {
        let a = makeVideo(id: "abc", title: "Same")
        let b = makeVideo(id: "abc", title: "Same")
        #expect(a == b)
    }

    @Test("Equatable: different IDs are not equal")
    func notEqual() {
        let a = makeVideo(id: "abc")
        let b = makeVideo(id: "xyz")
        #expect(a != b)
    }

    @Test("Identifiable: id property matches")
    func identifiable() {
        let video = makeVideo(id: "myVideo")
        #expect(video.id == "myVideo")
    }

    @Test("Init sets all fields correctly")
    func initValidation() {
        let thumbnail = URL(string: "https://i.ytimg.com/vi/v1/hqdefault.jpg")!
        let url = URL(string: "https://www.youtube.com/watch?v=v1")!
        let video = Video(
            id: "v1",
            title: "Title",
            thumbnail: thumbnail,
            publishedAt: "Yesterday",
            url: url,
            channelTitle: "Channel"
        )
        #expect(video.id == "v1")
        #expect(video.title == "Title")
        #expect(video.thumbnail == thumbnail)
        #expect(video.publishedAt == "Yesterday")
        #expect(video.url == url)
        #expect(video.channelTitle == "Channel")
    }
}
