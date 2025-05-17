import Models
import Shared
import SwiftUI
import UI

struct YoutubePreferenceView: View {
    @Shared(.apiKey) private var apiKey

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                DisclosureGroup {
                    VStack(alignment: .leading) {
                        TextField("Your Google API Key", text: Binding($apiKey))
                            .textFieldStyle(.plain)
                            .thinRoundedBG()

                        Link(
                            destination: URL(string: "https://www.youtube.com/watch?v=WrFPERZb7uw")!,
                            label: {
                                HStack {
                                    Spacer()
                                    Label("How to get Google API Key?", systemImage: "globe")
                                    Spacer()
                                }
                            }
                        )
                    }

                } label: {
                    Label("Your Youtube API Key", systemImage: "person.badge.key.fill")
                        .bold()
                }
            }
            .thinRoundedBG()
        }
    }
}

#if DEBUG
#Preview {
    YoutubePreferenceView()
}
#endif
