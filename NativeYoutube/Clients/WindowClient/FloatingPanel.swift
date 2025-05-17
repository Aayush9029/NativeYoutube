import AppKit

class FloatingPanel: NSPanel {
    init(
        contentRect: NSRect = .zero,
        backing: NSWindow.BackingStoreType = .buffered,
        defer flag: Bool = false
    ) {
        super.init(
            contentRect: contentRect,
            styleMask: [
                .titled,
                .resizable,
                .closable,
                .fullSizeContentView,
                .nonactivatingPanel
            ],
            backing: backing,
            defer: flag
        )
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isFloatingPanel = true
        self.level = .floating
        self.collectionBehavior.insert(.fullScreenAuxiliary)
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.isReleasedWhenClosed = false
        self.standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true

        // Set minimum window size
        self.minSize = NSSize(width: 400, height: 300)
    }

    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }
}
