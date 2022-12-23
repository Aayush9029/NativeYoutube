//
//  View+Extension.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import Cocoa
import SwiftUI

extension View {
    private func newWindowInternal(with title: String, isTransparent: Bool = false) -> NSWindow {
        let window = KeyWindow(
            contentRect: NSRect(x: 20, y: 20, width: 640, height: 360),
            styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.makeKey()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(self)
        window.level = .floating
        // Failed attempt to make the window sticks at the right aspect ratio, keeping it in comment as it should work (see https://developer.apple.com/documentation/appkit/nswindow/1419507-aspectratio)
//        window.aspectRatio = NSMakeSize(16.0, 9.0)
        if isTransparent {
            window.backgroundColor = .clear
            window.isOpaque = false
            window.styleMask = [.hudWindow, .closable, .resizable]
            window.isMovableByWindowBackground = true
            window.makeKeyAndOrderFront(self)
        }
        window.setIsVisible(true)
        return window
    }

    func openNewWindow(with title: String = "New Window", isTransparent: Bool = false) {
        let window = newWindowInternal(with: title, isTransparent: isTransparent)
        window.contentView = NSHostingView(rootView: self)
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(self)
    }
}
