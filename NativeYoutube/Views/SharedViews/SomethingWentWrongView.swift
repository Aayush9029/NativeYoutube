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
                    Label(appStateViewModel.showingSettings ? "Settings Window Opened" : "Open settings",
                          systemImage: appStateViewModel.showingSettings ? "rectangle" : "gear")
                        .padding(10)
                        .background(.ultraThickMaterial)
                        .cornerRadius(10)
                    Spacer()
                }
                .onTapGesture {
                    if  !appStateViewModel.showingSettings {
                        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                    }
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
