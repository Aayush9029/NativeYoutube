//
//  View+Extension.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI
import Cocoa

extension View {
    private func newWindowInternal(with title: String, isTransparent: Bool?) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 20, y: 20, width: 680, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        window.becomeKey()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(self)
        window.level = .floating
        if let isTransparent = isTransparent{
            if isTransparent{
                window.backgroundColor             =  .clear
                window.isOpaque                      =   false
                window.styleMask                   =   .hudWindow
                window.isMovableByWindowBackground   =   true
                window.makeKeyAndOrderFront(self)
            }
        }
        window.setIsVisible(true)
        return window
    }
    
    func openNewWindow(with title: String = "New Window",  isTransparent: Bool?) {
        self.newWindowInternal(with: title, isTransparent: isTransparent).contentView = NSHostingView(rootView: self)
    }
}


//myWindow  = [[NSWindow alloc] initWithContentRect:frame
//                                                styleMask:NSBorderlessWindowMask
//                                                  backing:NSBackingStoreBuffered
//                                                    defer:NO];
//[myWindow setLevel:NSFloatingWindowLevel  ];
//[myWindow setBackgroundColor:[NSColor blueColor]];
//[myWindow makeKeyAndOrderFront:NSApp];
