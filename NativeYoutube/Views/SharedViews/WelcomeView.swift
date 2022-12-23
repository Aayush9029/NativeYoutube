//
//  WelcomeView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct WelcomeView: View {
    @State private var jump: Bool = false

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Welcome to")
                    .foregroundStyle(.secondary)
                Text("Native Youtube")
                    .font(.system(size: 64, design: .serif)).bold()

                    .foregroundStyle(.primary)
                Text("Enter your API credentials...")
                    .foregroundStyle(.tertiary)
            }
            .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Spacer()
                HStack {
                    Text("Click Gear Icon")
                    Image(systemName: "arrow.down")
                }
                .padding(6)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .shadow(radius: 4)
            }
            .offset(y: jump ? -30 : -10)
            .animation(.spring(response: 0.25).repeatForever(), value: jump)
            .onAppear {
                jump.toggle()
            }
        }
        .padding(.horizontal)
        .background(
            Image("AppIconImage")
                .resizable()
                .scaledToFit()
                .blur(radius: 96)
        )
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
