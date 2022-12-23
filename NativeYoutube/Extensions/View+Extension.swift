//
//  View+Extension.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import Cocoa
import SwiftUI

extension View {
    private func newWindowInternal(with title: String, isTransparent: Bool = false, appState: AppStateViewModel? = nil) -> NSWindow {
        let window = KeyWindow(
            contentRect: NSRect(x: 20, y: 20, width: 480, height: 270),
            styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.appState = appState

        window.makeKey()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(self)
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        // Failed attempt to make the window sticks at the right aspect ratio, keeping it in comment as it should work (see https://developer.apple.com/documentation/appkit/nswindow/1419507-aspectratio)
        if isTransparent {
            window.backgroundColor = .clear
            window.isOpaque = false
            window.styleMask = [.hudWindow, .closable, .resizable]
            window.isMovableByWindowBackground = true
        }
        window.setIsVisible(true)
        return window
    }

    func openNewWindow(with title: String = "New Window", isTransparent: Bool = false, appState: AppStateViewModel? = nil) {
        let window = newWindowInternal(with: title, isTransparent: isTransparent, appState: appState)
        window.contentView = NSHostingView(rootView: self)
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(self)
    }
}
