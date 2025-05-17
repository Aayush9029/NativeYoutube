import AppKit
import Dependencies
import SwiftUI
import UI

public struct WindowClient {
    public var createMainWindow: @MainActor () -> Void
    public var createPopupPlayerWindow: @MainActor (URL, String) -> Void
    public var closePopupPlayer: @MainActor () -> Void
    public var isPopupPlayerVisible: @MainActor () -> Bool
}

extension WindowClient: TestDependencyKey {
    public static let previewValue: Self = Self(
        createMainWindow: {
            print("Preview: Creating main window")
        },
        createPopupPlayerWindow: { url, title in
            print("Preview: Creating popup player for '\(title)' at \(url)")
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
            
            createPopupPlayerWindow: { url, title in
                let window = NSWindow(
                    contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
                    styleMask: [.titled, .closable, .resizable],
                    backing: .buffered,
                    defer: false
                )
                
                window.title = title
                window.center()
                
                let keyWindow = KeyWindow()
                keyWindow.onStop = {
                    WindowState.shared.popupPlayerWindow?.close()
                    WindowState.shared.popupPlayerWindow = nil
                }
                
                let popupView = PopupPlayerView(
                    title: title,
                    onClose: {
                        WindowState.shared.popupPlayerWindow?.close()
                        WindowState.shared.popupPlayerWindow = nil
                    }
                ) {
                    Text("Loading video...")
                        .frame(width: 600, height: 400)
                }
                
                keyWindow.contentView = NSHostingView(rootView: popupView)
                keyWindow.contentViewController = NSHostingController(rootView: popupView)
                keyWindow.makeKeyAndOrderFront(nil)
                
                WindowState.shared.popupPlayerWindow = keyWindow
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
    public var windowClient: WindowClient {
        get { self[WindowClient.self] }
        set { self[WindowClient.self] = newValue }
    }
}