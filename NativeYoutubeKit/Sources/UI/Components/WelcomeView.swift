import Assets
import SwiftUI

public struct WelcomeView: View {
    @State private var jump: Bool = false

    public init() {}

    public var body: some View {
        VStack {
            Spacer()
            VStack {
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
                        .foregroundStyle(.secondary)
                    Image(systemName: "arrow.down")
                }
                .padding(.horizontal, 12)
                .padding(4)
                .thinRoundedBG(padding: 4)
                .shadow(radius: 4)
            }
            .offset(y: jump ? -20 : -10)
            .animation(.spring(response: 0.5).repeatForever(), value: jump)
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

#if DEBUG
#Preview("Welcome View") {
    WelcomeView()
        .frame(width: 600, height: 400)
}
#endif
