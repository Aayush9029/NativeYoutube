//
//  View+Extension.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI
import Cocoa

extension View {
    private func newWindowInternal(with title: String, isTransparent: Bool = false) -> NSWindow {
        let window = KeyWindow(
            contentRect: NSRect(x: 20, y: 20, width: 680, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.makeKey()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(self)
        window.level = .floating
        if isTransparent{
            window.backgroundColor =  .clear
            window.isOpaque = false
            window.styleMask = [.hudWindow, .closable]
            window.isMovableByWindowBackground = true
            window.makeKeyAndOrderFront(self)
        }
        window.setIsVisible(true)
        return window
    }

    func openNewWindow(with title: String = "New Window",  isTransparent: Bool = false) {
        let window = newWindowInternal(with: title, isTransparent: isTransparent)
        window.contentView = NSHostingView(rootView: self)
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(self)
    }
}
