import Models
import Shared
import SwiftUI
import UI

struct GeneralPreferenceView: View {
    @Shared(.playlistID) private var playlistID
    @Shared(.useIINA) private var useIINA
    @Shared(.videoClickBehaviour) private var videoClickBehaviour

    var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup {
                TextField("Playlist ID", text: Binding($playlistID))
                    .textFieldStyle(.plain)
                    .thinRoundedBG()
            } label: {
                Label("Custom Playlist ID", systemImage: "music.note.list")
                    .bold()
            }
            .thinRoundedBG()

            Divider()
                .opacity(0.5)

            DisclosureGroup {
                VStack {
                    SpacedToggle("Use IINA", isOn: Binding($useIINA))

                    Picker("Double Click to", selection: Binding($videoClickBehaviour)) {
                        ForEach(VideoClickBehaviour.allCases, id: \.self) { behaviour in
                            if behaviour != .playInIINA || useIINA {
                                Text(behaviour.rawValue).tag(behaviour)
                            }
                        }
                    }
                }
                .thinRoundedBG()
            } label: {
                Label("Player Settings", systemImage: "play.rectangle.on.rectangle.fill")
                    .bold()
            }
            .thinRoundedBG()
        }
    }
}

struct SpacedToggle: View {
    let title: String
    @Binding var isOn: Bool

    init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .labelsHidden()
        }
    }
}
