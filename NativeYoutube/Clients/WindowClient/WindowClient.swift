import AppKit
import Dependencies
import SwiftUI

public struct WindowClient {
    public var createMainWindow: @MainActor () -> Void
    public var createPopupPlayerWindow: @MainActor (URL, String, @escaping () -> Void) -> Void
    public var setPopupPlayerContent: @MainActor (any View) -> Void
    public var closePopupPlayer: @MainActor () -> Void
    public var isPopupPlayerVisible: @MainActor () -> Bool
}

extension WindowClient: DependencyKey {
    public static let previewValue: Self = .init(
        createMainWindow: {
            print("Preview: Creating main window")
        },
        createPopupPlayerWindow: { url, title, _ in
            print("Preview: Creating popup player for '\(title)' at \(url)")
        },
        setPopupPlayerContent: { _ in
            print("Preview: Setting popup player content")
        },
        closePopupPlayer: {
            print("Preview: Closing popup player")
        },
        isPopupPlayerVisible: {
            print("Preview: Checking if popup player is visible")
            return false
        }
    )
    
    public static let testValue = previewValue
    
    public static let liveValue: Self = {
        @MainActor
        final class WindowState {
            var mainWindow: NSWindow?
            var popupPlayerWindow: NSWindow?
            static let shared = WindowState()
            private init() {}
        }
        
        return Self(
            createMainWindow: {
                let window = NSWindow(
                    contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
                    styleMask: [.titled, .closable, .miniaturizable, .resizable],
                    backing: .buffered,
                    defer: false
                )
                
                window.title = "Native Youtube"
                window.center()
                window.makeKeyAndOrderFront(nil)
                
                WindowState.shared.mainWindow = window
            },
            
            createPopupPlayerWindow: { _, title, onClose in
                if WindowState.shared.popupPlayerWindow != nil {
                    WindowState.shared.popupPlayerWindow?.makeKeyAndOrderFront(nil)
                    return
                }
                
                let window = KeyWindow()
                window.setFrame(NSRect(x: 0, y: 0, width: 600, height: 400), display: false)
                window.title = title
                window.center()
                window.styleMask = [.titled, .closable, .resizable]
                window.level = .floating
                
                window.onStop = {
                    onClose()
                    WindowState.shared.popupPlayerWindow?.close()
                    WindowState.shared.popupPlayerWindow = nil
                }
                
                WindowState.shared.popupPlayerWindow = window
                window.makeKeyAndOrderFront(nil)
            },
            
            setPopupPlayerContent: { view in
                if let popupWindow = WindowState.shared.popupPlayerWindow {
                    popupWindow.contentView = NSHostingView(rootView: AnyView(view))
                }
            },
            
            closePopupPlayer: {
                WindowState.shared.popupPlayerWindow?.close()
                WindowState.shared.popupPlayerWindow = nil
            },
            
            isPopupPlayerVisible: {
                WindowState.shared.popupPlayerWindow?.isVisible ?? false
            }
        )
    }()
}

extension DependencyValues {
    var windowClient: WindowClient {
        get { self[WindowClient.self] }
        set { self[WindowClient.self] = newValue }
    }
}
