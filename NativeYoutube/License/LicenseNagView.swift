import SwiftUI

struct LicenseNagView: View {
    @Environment(LicenseManager.self) private var licenseManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingActivation = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Enjoying NativeYoutube?")
                .font(.headline)

            Text("Support development by purchasing a license. The app is fully functional — a license removes these reminders.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 10) {
                Link(destination: URL(string: "https://aayushbuilds.gumroad.com/l/YouTube")!) {
                    HStack {
                        Spacer()
                        Label("Purchase License — $12.99", systemImage: "cart.fill")
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)

                Button {
                    showingActivation = true
                } label: {
                    HStack {
                        Spacer()
                        Text("I have a license key")
                        Spacer()
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)

                Button("Later") {
                    dismiss()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .font(.caption)
            }
        }
        .padding(24)
        .frame(width: 320)
        .sheet(isPresented: $showingActivation) {
            LicenseActivationView()
                .environment(licenseManager)
        }
    }
}
