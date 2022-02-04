//
//  StatusBarController.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import AppKit

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var eventMonitor: EventMonitor?
    
    init(_ popover: NSPopover)
    {
        self.popover = popover
        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 28.0)
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = #imageLiteral(resourceName: "StatusBarIcon")
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
            
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }

        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
    }
    
    @objc func togglePopover(sender: AnyObject) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
            eventMonitor?.start()
        }
    }
    
    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if(popover.isShown) {
            hidePopover(event!)
        }
    }
}
