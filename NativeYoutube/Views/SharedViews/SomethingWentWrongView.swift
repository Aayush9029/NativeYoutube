//
//  SomethingWentWrongView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct SomethingWentWrongView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    var body: some View {
        Group {
            VStack(spacing: 10) {
                Text("Something went wrong 🥶")
                    .font(.largeTitle.bold())
                Text("Check your API credentials...")
                    .bold()
                    .foregroundStyle(.primary)
                HStack {
                    Spacer()
                    Button(action: {
                        if  !appStateViewModel.showingSettings {
//                          Since MacOS Ventura (13.0), settings window shows by calling showSettingsWindow and not showPreferencesWindow.
                            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                        }
                    }, label: {
                        Label(appStateViewModel.showingSettings ? "Settings Window Opened" : "Open settings",
                              systemImage: appStateViewModel.showingSettings ? "rectangle" : "gear")
                    }).padding(10)
                        .background(.ultraThickMaterial)
                        .cornerRadius(10)
                        .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct SomethingWentWrongView_Previews: PreviewProvider {
    static var previews: some View {
        SomethingWentWrongView()
            .environmentObject(AppStateViewModel())
    }
}
