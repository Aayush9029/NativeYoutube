import SwiftUI
import UI

struct LicensePreferenceView: View {
    @Environment(LicenseManager.self) private var licenseManager
    @State private var showingActivation = false

    var body: some View {
        VStack(alignment: .leading) {
            DisclosureGroup {
                VStack(alignment: .leading, spacing: 8) {
                    if licenseManager.isActivated {
                        HStack {
                            Label("Licensed", systemImage: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                            Spacer()
                            Button("Deactivate") {
                                licenseManager.deactivate()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                    } else {
                        HStack {
                            Button("Activate Key") {
                                showingActivation = true
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)

                            Spacer()

                            Link("Purchase", destination: URL(string: "https://aayushbuilds.gumroad.com/l/YouTube")!)
                                .font(.caption)
                        }
                    }
                }
                .thinRoundedBG()
            } label: {
                Label("License", systemImage: "key.fill")
                    .bold()
            }
            .thinRoundedBG()
        }
        .sheet(isPresented: $showingActivation) {
            LicenseActivationView()
                .environment(licenseManager)
        }
    }
}
