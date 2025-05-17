import SwiftUI
import Assets

public struct WelcomeView: View {
    @State private var jump: Bool = false
    
    public init() {}
    
    public var body: some View {
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
                .thinRoundedBG(padding: 4)
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
            Assets.appIcon
                .resizable()
                .scaledToFit()
                .blur(radius: 96)
        )
    }
}

#Preview("Welcome View") {
    WelcomeView()
        .frame(width: 600, height: 400)
}