import Foundation

public enum VideoClickBehaviour: String, CaseIterable, Codable {
    case nothing = "Do Nothing"
    case playVideo = "Play Video"
    case openOnYoutube = "Open on Youtube"
    case playInIINA = "Play Using IINA"
}