import SwiftUI
import AppKit

struct LicenseActivationView: View {
    private static let minimumKeyLength = 3
    private static let maximumKeyLength = 64

    @Environment(LicenseManager.self) private var licenseManager
    @Environment(\.dismiss) private var dismiss
    @State private var keyInput = ""
    @State private var inputValidationError: String?
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
        VStack(spacing: 0) {
            Spacer(minLength: 20)

            LicensePromptHeader(
                symbol: "key.fill",
                symbolColor: .orange,
                title: "Activate License",
                subtitle: "Paste your key to unlock reminders."
            )
            .frame(maxWidth: 340)

            Spacer(minLength: 26)

            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    TextField("Enter your license key", text: $keyInput)
                        .textFieldStyle(.plain)
                        .font(.callout.monospaced())
                        .lineLimit(1)
                        .onChange(of: keyInput) { _, _ in
                            inputValidationError = nil
                        }

                    Button {
                        pasteLicenseKeyFromClipboard()
                    } label: {
                        Image(systemName: "clipboard.fill")
                            .font(.callout.weight(.semibold))
                            .frame(width: 26, height: 26)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .help("Paste from clipboard")
                }
                .padding(.horizontal, 12)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.white.opacity(0.18), lineWidth: 1)
                )

                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(spacing: 10) {
                    Button {
                        activateLicense()
                    } label: {
                        Label("Activate", systemImage: "heart.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(LicenseDarkActionButtonStyle())
                    .controlSize(.large)
                    .keyboardShortcut(.defaultAction)
                    .disabled(!isKeyLengthValid || licenseManager.isActivating)

                    Link(destination: URL(string: "https://aayushbuilds.gumroad.com/l/YouTube")!) {
                        Label("Get a license", systemImage: "cart.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .frame(maxWidth: 340)

            Spacer(minLength: 0)

            LicenseSecondaryAction(title: "I don’t want to") {
                if let onCancel {
                    onCancel()
                } else {
                    dismiss()
                }
            }
            .keyboardShortcut(.cancelAction)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background(LicensePromptBackground())
        .navigationBarBackButtonHidden(true)
    }

    private var normalizedKey: String {
        keyInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isKeyLengthValid: Bool {
        let length = normalizedKey.count
        return (Self.minimumKeyLength...Self.maximumKeyLength).contains(length)
    }

    private var errorMessage: String? {
        inputValidationError ?? licenseManager.activationError
    }

    private func activateLicense() {
        guard isKeyLengthValid else {
            inputValidationError = "License key must be 3-64 characters."
            return
        }

        inputValidationError = nil
        Task {
            await licenseManager.activate(key: normalizedKey)
            if licenseManager.isActivated {
                if let onActivated {
                    onActivated()
                } else {
                    dismiss()
                }
            }
        }
    }

    private func pasteLicenseKeyFromClipboard() {
        guard let rawValue = NSPasteboard.general.string(forType: .string) else {
            inputValidationError = "Clipboard doesn't contain text."
            return
        }

        let candidate = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let length = candidate.count
        guard (Self.minimumKeyLength...Self.maximumKeyLength).contains(length) else {
            inputValidationError = "Clipboard key must be 3-64 characters."
            return
        }

        keyInput = candidate
        inputValidationError = nil
    }
}
