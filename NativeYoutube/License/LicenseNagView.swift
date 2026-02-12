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
            VStack(spacing: 0) {
                Spacer(minLength: 20)

                LicensePromptHeader(
                    symbol: "heart.fill",
                    symbolColor: .red,
                    title: "Enjoying NativeYoutube?",
                    subtitle: "A license removes reminders and supports NativeYoutube."
                )
                .frame(maxWidth: 340)

                Spacer(minLength: 26)

                HStack(spacing: 10) {
                    Link(destination: URL(string: "https://aayushbuilds.gumroad.com/l/YouTube")!) {
                        Label("Purchase", systemImage: "cart.fill")
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
                    .buttonStyle(LicenseDarkActionButtonStyle())
                    .controlSize(.large)
                }
                .frame(maxWidth: 340)

                Spacer(minLength: 0)

                LicenseSecondaryAction(title: "I don’t want to") {
                    if let onLater {
                        onLater()
                    } else {
                        dismiss()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(24)
            .background(LicensePromptBackground())
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
}
