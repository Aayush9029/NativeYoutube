import AppKit
import Dependencies
import SwiftUI

public struct WindowClient {
    public var createMainWindow: @MainActor () -> Void
    public var createPopupPlayerWindow: @MainActor (URL, String, @escaping () -> Void) -> Void
    public var closePopupPlayer: @MainActor () -> Void
    public var isPopupPlayerVisible: @MainActor () -> Bool
    public var setPopupPlayerContent: @MainActor (AnyView) -> Void
}

extension WindowClient: DependencyKey {
    public static let previewValue: Self = .init(
        createMainWindow: {
            print("Preview: Creating main window")
        },
        createPopupPlayerWindow: { url, title, _ in
            print("Preview: Creating popup player for '\(title)' at \(url)")
        },
        closePopupPlayer: {
            print("Preview: Closing popup player")
        },
        isPopupPlayerVisible: {
            print("Preview: Checking if popup player is visible")
            return false
        },
        setPopupPlayerContent: { _ in
            print("Preview: Setting popup player content")
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
            
            createPopupPlayerWindow: { url, title, onClose in
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
                
                // Store the URL and title for later use
                window.videoURL = url
                window.videoTitle = title
                
                WindowState.shared.popupPlayerWindow = window
                window.makeKeyAndOrderFront(nil)
            },
            
            closePopupPlayer: {
                WindowState.shared.popupPlayerWindow?.close()
                WindowState.shared.popupPlayerWindow = nil
            },
            
            isPopupPlayerVisible: {
                WindowState.shared.popupPlayerWindow?.isVisible ?? false
            },
            
            setPopupPlayerContent: { view in
                if let window = WindowState.shared.popupPlayerWindow {
                    window.contentView = NSHostingView(rootView: view)
                }
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
