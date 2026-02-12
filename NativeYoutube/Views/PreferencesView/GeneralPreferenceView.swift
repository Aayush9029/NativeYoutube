import Models
import Sharing
import SwiftUI

struct GeneralPreferenceView: View {
    @Shared(.playlistID) private var playlistID
    @Shared(.useIINA) private var useIINA
    @Shared(.videoClickBehaviour) private var videoClickBehaviour
    @Shared(.autoCheckUpdates) private var autoCheckUpdates
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        SettingsCard(
            title: "General",
            subtitle: "Playlist, playback, and update behavior",
            symbol: "slider.horizontal.3"
        ) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Custom Playlist ID")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.72))

                    TextField("Playlist ID", text: Binding($playlistID))
                        .textFieldStyle(.plain)
                        .settingsInputFieldStyle()
                }

                SettingsRow(
                    title: "Use IINA",
                    subtitle: "Enable IINA as an available playback target."
                ) {
                    Toggle("Use IINA", isOn: Binding($useIINA))
                        .toggleStyle(.switch)
                        .labelsHidden()
                        .tint(Color(red: 0.98, green: 0.38, blue: 0.47))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Double-click action")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.72))

                    Picker("Double-click action", selection: Binding($videoClickBehaviour)) {
                        ForEach(VideoClickBehaviour.allCases, id: \.self) { behaviour in
                            if behaviour != .playInIINA || useIINA {
                                Text(behaviour.rawValue)
                                    .tag(behaviour)
                            }
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .settingsInputFieldStyle()
                }

                SettingsRow(
                    title: "Automatic updates",
                    subtitle: "Check for updates in the background."
                ) {
                    Toggle("Automatic updates", isOn: Binding($autoCheckUpdates))
                        .toggleStyle(.switch)
                        .labelsHidden()
                        .tint(Color(red: 0.98, green: 0.38, blue: 0.47))
                }

                Button("Check for Updates Now") {
                    coordinator.checkForUpdates()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .tint(Color(red: 0.98, green: 0.38, blue: 0.47))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
