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
        VStack(spacing: 16) {
            Text("Activate License")
                .font(.headline)

            TextField("Enter your license key", text: $keyInput)
                .textFieldStyle(.roundedBorder)

            if let error = licenseManager.activationError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            HStack(spacing: 12) {
                Button("Cancel") {
                    if let onCancel {
                        onCancel()
                    } else {
                        dismiss()
                    }
                }
                .keyboardShortcut(.cancelAction)

                Button("Activate") {
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
                }
                .keyboardShortcut(.defaultAction)
                .disabled(keyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || licenseManager.isActivating)
            }

            Divider()

            Link("Purchase a license on Gumroad", destination: URL(string: "https://aayushbuilds.gumroad.com/l/YouTube")!)
                .font(.caption)
        }
        .padding(24)
        .frame(width: 320)
    }
}
