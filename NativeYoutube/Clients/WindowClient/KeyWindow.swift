import AppKit

class KeyWindow: NSWindow {
    var onStop: (() -> Void)?
    var videoURL: URL?
    var videoTitle: String?

    override var canBecomeKey: Bool {
        return true
    }

    override func keyDown(with event: NSEvent) {
        if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command && event.charactersIgnoringModifiers == "w" {
            onStop?()
            close()
            return
        } else {
            super.keyDown(with: event)
        }
    }
}
