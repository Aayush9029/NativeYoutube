import SwiftUI
import SwiftUINavigation

struct LicenseNagView: View {
    private enum Destination {
        case activation
    }

    @Environment(LicenseManager.self) private var licenseManager
    @Environment(\.dismiss) private var dismiss
    @State private var destination: Destination?
    var onLater: (() -> Void)?
    var onActivated: (() -> Void)?

    init(
        onLater: (() -> Void)? = nil,
        onActivated: (() -> Void)? = nil
    ) {
        self.onLater = onLater
        self.onActivated = onActivated
    }

    var body: some View {
        NavigationStack {
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
                        destination = .activation
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
                        if let onLater {
                            onLater()
                        } else {
                            dismiss()
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .font(.caption)
                }
            }
            .padding(24)
            .frame(width: 320)
            .navigationDestination(item: $destination) { destination in
                switch destination {
                case .activation:
                    LicenseActivationView(
                        onCancel: { self.destination = nil },
                        onActivated: {
                            if let onActivated {
                                onActivated()
                            } else {
                                dismiss()
                            }
                        }
                    )
                    .environment(licenseManager)
                }
            }
        }
    }
}
