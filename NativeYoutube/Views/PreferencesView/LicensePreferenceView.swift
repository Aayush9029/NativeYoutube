import SwiftUI

struct LicensePreferenceView: View {
    @Environment(LicenseManager.self) private var licenseManager

    var body: some View {
        SettingsCard(
            title: "License",
            subtitle: "Activation and purchase controls",
            symbol: "key.fill"
        ) {
            VStack(alignment: .leading, spacing: 10) {
                if licenseManager.isActivated {
                    SettingsRow(
                        title: "Status",
                        subtitle: "This device is fully activated."
                    ) {
                        Label("Licensed", systemImage: "checkmark.seal.fill")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(.green)
                    }

                    Button("Deactivate License") {
                        licenseManager.deactivate()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("Activate to remove reminders and support NativeYoutube.")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.74))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.black.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(.white.opacity(0.08), lineWidth: 1)
                                )
                        )

                    HStack(spacing: 8) {
                        Button("Activate Key") {
                            licenseManager.presentActivationOverlay()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                        .tint(Color(red: 0.98, green: 0.38, blue: 0.47))

                        Link("Purchase", destination: URL(string: "https://aayushbuilds.gumroad.com/l/YouTube")!)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .tint(.white)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
        }
    }
}
