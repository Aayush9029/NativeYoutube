//
//  SomethingWentWrongView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct SomethingWentWrongView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        Group{
            VStack(spacing: 10){
                Spacer()
                Text("Something went wrong 🥶")
                    .font(.largeTitle.bold())
                Text("Check your API credentials...")
                    .bold()
                    .foregroundStyle(.primary)
                HStack{
                    Spacer()
                    Label(settingsViewModel.showingSettings ? "Settings Window Opened" : "Open settings", systemImage:settingsViewModel.showingSettings ? "rectangle" : "gear")
                        .padding(10)
                        .background(.ultraThickMaterial)
                        .cornerRadius(10)
                    Spacer()
                }
                .onTapGesture {
                    if  !settingsViewModel.showingSettings{
                        SettingsView()
                            .environmentObject(settingsViewModel)
                            .background(VisualEffectView(material: NSVisualEffectView.Material.hudWindow, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
                            .openNewWindow(with: "Native Youtube Settings", isTransparent: false)
                    }
                }
            }
        }
    }
}

struct SomethingWentWrongView_Previews: PreviewProvider {
    static var previews: some View {
        SomethingWentWrongView()
            .environmentObject(SettingsViewModel())
    }
}
