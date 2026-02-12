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
            VStack(spacing: 20) {
                Spacer(minLength: 16)

                Image(systemName: "heart.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.red)

                Text("Enjoying NativeYoutube?")
                    .font(.title2.weight(.bold))

                Text("A license removes reminders and supports NativeYoutube.")
                    .font(.body.weight(.medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    Link(destination: URL(string: "https://aayushbuilds.gumroad.com/l/YouTube")!) {
                        Label("Purchase License — $12.99", systemImage: "cart.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button {
                        destination = .activation
                    } label: {
                        Text("I have a license key")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                    Button("I don’t want to") {
                        if let onLater {
                            onLater()
                        } else {
                            dismiss()
                        }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                .frame(maxWidth: 320)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(24)
            .background(backgroundGradient)
            .navigationDestination(item: $destination) { destination in
                switch destination {
                case .activation:
                    LicenseActivationView(
                        onCancel: {
                            self.destination = nil
                        },
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.16, green: 0.07, blue: 0.10),
                Color(red: 0.07, green: 0.09, blue: 0.14)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
