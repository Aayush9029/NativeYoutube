import AppKit

class KeyWindow: NSWindow {
    var onStop: (() -> Void)?

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
