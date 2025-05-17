import AppKit
import Dependencies
import OSLog
import SwiftUI

public struct FloatingWindowClient {
    public var createFloatingPanel: @MainActor (NSView) -> Void
    public var isVisible: @MainActor () -> Bool
    public var showPanel: @MainActor () -> Void
    public var hidePanel: @MainActor () -> Void
    public var centerPanel: @MainActor () -> Void
    public var updateContent: @MainActor (NSView) -> Void
    public var setCloseHandler: @MainActor (@escaping () -> Void) -> Void
}

// Helper to hold window state outside of the main implementation
private extension FloatingWindowClient {
    @MainActor
    final class WindowStateHolder {
        var floatingPanel: FloatingPanel?
        var closeHandler: (() -> Void)?
        static let shared = WindowStateHolder()
    }
}

extension FloatingWindowClient: DependencyKey {
    public static let liveValue: Self = {
        let state = WindowStateHolder.shared
        
        return Self(
            createFloatingPanel: { contentView in
                let panel = FloatingPanel(
                    contentRect: NSRect(x: 0, y: 0, width: 800, height: 420),
                    backing: .buffered,
                    defer: false
                )
                panel.titleVisibility = .hidden
                panel.backgroundColor = .clear
                panel.animationBehavior = .utilityWindow
                panel.contentView = contentView
                
                // Set up default close handler to clean up state
                let delegate = PanelDelegate()
                panel.delegate = delegate
                
                state.floatingPanel = panel
                center(panel: state.floatingPanel)
            },
            
            isVisible: {
                state.floatingPanel?.isVisible ?? false
            },
            
            showPanel: {
                guard let panel = state.floatingPanel else { return }
                panel.makeKeyAndOrderFront(nil)
            },
            
            hidePanel: {
                state.floatingPanel?.orderOut(nil)
            },
            
            centerPanel: {
                center(panel: state.floatingPanel)
            },
            
            updateContent: { contentView in
                guard let panel = state.floatingPanel else { return }
                panel.contentView = contentView
            },
            
            setCloseHandler: { handler in
                state.closeHandler = handler
            }
        )
        
        func center(panel: NSPanel?) {
            guard let panel, let screen = NSScreen.main else { return }
                
            let screenRect = screen.visibleFrame
            let panelRect = panel.frame
                
            let newOrigin = NSPoint(
                x: screenRect.midX - panelRect.width / 2,
                y: screenRect.midY - panelRect.height / 2
            )
                
            panel.setFrameOrigin(newOrigin)
        }
    }()
}

// Panel delegate to handle cleanup
@MainActor
private class PanelDelegate: NSObject, NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        if notification.object is FloatingPanel {
            let state = FloatingWindowClient.WindowStateHolder.shared
            state.closeHandler?()
            state.floatingPanel = nil
            state.closeHandler = nil
        }
    }
}

extension FloatingWindowClient: TestDependencyKey {
    public static let testValue = Self(
        createFloatingPanel: unimplemented("\(Self.self).createFloatingPanel"),
        isVisible: unimplemented("\(Self.self).isVisible", placeholder: false),
        showPanel: unimplemented("\(Self.self).showPanel"),
        hidePanel: unimplemented("\(Self.self).hidePanel"),
        centerPanel: unimplemented("\(Self.self).centerPanel"),
        updateContent: unimplemented("\(Self.self).updateContent"),
        setCloseHandler: unimplemented("\(Self.self).setCloseHandler")
    )
    
    public static let noop = Self(
        createFloatingPanel: { _ in },
        isVisible: { false },
        showPanel: {},
        hidePanel: {},
        centerPanel: {},
        updateContent: { _ in },
        setCloseHandler: { _ in }
    )
}

public extension DependencyValues {
    var floatingWindowClient: FloatingWindowClient {
        get { self[FloatingWindowClient.self] }
        set { self[FloatingWindowClient.self] = newValue }
    }
}

// Keep this for backwards compatibility but it now uses FloatingWindowClient internally
public extension DependencyValues {
    var youTubePlayerWindowClient: FloatingWindowClient {
        get { self[FloatingWindowClient.self] }
        set { self[FloatingWindowClient.self] = newValue }
    }
}
