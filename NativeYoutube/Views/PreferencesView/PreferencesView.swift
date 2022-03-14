//
//  PreferencesView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/4/22.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    var body: some View {
        TabView {
//             Not fully implemented as of now
            GeneralPreferenceView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            YoutubePreferenceView()
                .tabItem {
                    Label("Youtube", systemImage: "play")
                }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification, object: nil), perform: { notification in
            if let prefWindow = notification.object as? NSWindow, prefWindow.toolbarStyle == .preference {
                appStateViewModel.showingSettings = true
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification, object: nil), perform: { notification in
            if let prefWindow = notification.object as? NSWindow, prefWindow.toolbarStyle == .preference {
                // We listen to events when the the preference window is closing.
                // .onDisappear does not work well when we use `Settings` scene. Bug on SwiftUI?
                appStateViewModel.showingSettings = false
            }
        })
    }
}

struct PreferencesView_Preview: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(AppStateViewModel())
    }
}
