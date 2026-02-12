import Sharing
import SwiftUI

struct YoutubePreferenceView: View {
    @Shared(.apiKey) private var apiKey

    var body: some View {
        SettingsCard(
            title: "YouTube API",
            subtitle: "Credentials for search and playlist loading",
            symbol: "person.badge.key.fill"
        ) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Google API Key")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.72))

                    TextField("Your Google API key", text: Binding($apiKey))
                        .textFieldStyle(.plain)
                        .settingsInputFieldStyle()
                }

                Link(destination: URL(string: "https://www.youtube.com/watch?v=WrFPERZb7uw")!) {
                    Label("How to get a Google API key", systemImage: "globe")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(Color(red: 0.98, green: 0.38, blue: 0.47))
            }
        }
    }
}

#if DEBUG
#Preview {
    YoutubePreferenceView()
}
#endif
