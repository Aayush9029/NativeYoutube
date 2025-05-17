import AppKit

public class KeyWindow: NSWindow {
    public var onStop: (() -> Void)?
    
    public override var canBecomeKey: Bool {
        return true
    }
    
    public override func keyDown(with event: NSEvent) {
        if event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command && event.charactersIgnoringModifiers == "w" {
            onStop?()
            close()
            return
        } else {
            super.keyDown(with: event)
        }
    }
}