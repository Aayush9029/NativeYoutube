//
//  MainHostingViewController.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import AppKit
import SwiftUI

class MainHostingViewController<Content>: NSHostingController<Content> where Content: View {
    override func viewDidAppear()
    {
        super.viewDidAppear()

        // You can use a notification and observe it in a view model where you want to fetch the data for your SwiftUI view every time the popover appears.
        // NotificationCenter.default.post(name: Notification.Name("ViewDidAppear"), object: nil)
    }
}
