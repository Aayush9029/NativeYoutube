import SwiftUI

struct LicenseActivationView: View {
    @Environment(LicenseManager.self) private var licenseManager
    @Environment(\.dismiss) private var dismiss
    @State private var keyInput = ""
    var onCancel: (() -> Void)?
    var onActivated: (() -> Void)?

    init(
        onCancel: (() -> Void)? = nil,
        onActivated: (() -> Void)? = nil
    ) {
        self.onCancel = onCancel
        self.onActivated = onActivated
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 16)

            Image(systemName: "key.fill")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.orange)

            Text("Activate License")
                .font(.title2.weight(.bold))

            Text("Paste your key to unlock reminders.")
                .font(.body.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                TextField("Enter your license key", text: $keyInput)
                    .textFieldStyle(.roundedBorder)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity)

                if let error = licenseManager.activationError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button {
                    Task {
                        await licenseManager.activate(key: keyInput.trimmingCharacters(in: .whitespacesAndNewlines))
                        if licenseManager.isActivated {
                            if let onActivated {
                                onActivated()
                            } else {
                                dismiss()
                            }
                        }
                    }
                } label: {
                    Label("Activate", systemImage: "heart.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
                .disabled(keyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || licenseManager.isActivating)

                Button("I don’t want to") {
                    if let onCancel {
                        onCancel()
                    } else {
                        dismiss()
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .keyboardShortcut(.cancelAction)
            }
            .frame(maxWidth: 340)

            Link("Purchase a license on Gumroad", destination: URL(string: "https://aayushbuilds.gumroad.com/l/YouTube")!)
                .font(.callout.weight(.medium))

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .navigationBarBackButtonHidden(true)
    }
}
