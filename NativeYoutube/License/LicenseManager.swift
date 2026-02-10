import Foundation
import Sharing

@MainActor
@Observable
final class LicenseManager {
    var activationError: String?
    var isActivating = false

    @ObservationIgnored @Shared(.licenseKey) var licenseKey
    @ObservationIgnored @Shared(.isLicenseActivated) var isLicenseActivated
    @ObservationIgnored @Shared(.deviceID) var deviceID
    @ObservationIgnored @Shared(.launchCount) var launchCount

    var isActivated: Bool { isLicenseActivated }

    var shouldShowNag: Bool {
        !isLicenseActivated && launchCount > 0 && launchCount % 5 == 0
    }

    init() {
        if deviceID.isEmpty {
            $deviceID.withLock { $0 = UUID().uuidString }
        }
        $launchCount.withLock { $0 += 1 }
    }

    func activate(key: String) async {
        isActivating = true
        activationError = nil

        do {
            let response = try await GumroadAPI.verify(licenseKey: key, incrementUses: true)

            guard response.success, let purchase = response.purchase else {
                activationError = response.message ?? GumroadError.licenseNotFound.errorDescription
                isActivating = false
                return
            }

            if purchase.refunded {
                activationError = GumroadError.refunded.errorDescription
                isActivating = false
                return
            }

            if purchase.disputed || purchase.chargebackDate != nil {
                activationError = GumroadError.disputed.errorDescription
                isActivating = false
                return
            }

            if purchase.uses > 3 {
                activationError = GumroadError.deviceLimitReached.errorDescription
                isActivating = false
                return
            }

            $licenseKey.withLock { $0 = key }
            $isLicenseActivated.withLock { $0 = true }
            activationError = nil
        } catch {
            activationError = error.localizedDescription
        }

        isActivating = false
    }

    func validateExisting() async {
        guard isLicenseActivated, !licenseKey.isEmpty else { return }

        do {
            let response = try await GumroadAPI.verify(licenseKey: licenseKey, incrementUses: false)

            if let purchase = response.purchase {
                if purchase.refunded || purchase.disputed || purchase.chargebackDate != nil {
                    deactivate()
                }
            } else if !response.success {
                deactivate()
            }
        } catch {
            // Ignore network errors during background re-validation
        }
    }

    func deactivate() {
        $licenseKey.withLock { $0 = "" }
        $isLicenseActivated.withLock { $0 = false }
        activationError = nil
    }
}
