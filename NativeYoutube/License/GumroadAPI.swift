import Foundation

enum GumroadError: LocalizedError {
    case networkError(Error)
    case licenseNotFound
    case deviceLimitReached
    case refunded
    case disputed

    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .licenseNotFound:
            return "License key not found."
        case .deviceLimitReached:
            return "This license has been activated on too many devices."
        case .refunded:
            return "This license has been refunded."
        case .disputed:
            return "This license has a payment dispute."
        }
    }
}

struct GumroadPurchase: Codable {
    let email: String?
    let licenseKey: String
    let uses: Int
    let refunded: Bool
    let disputed: Bool
    let chargebackDate: String?

    enum CodingKeys: String, CodingKey {
        case email
        case licenseKey = "license_key"
        case uses
        case refunded
        case disputed
        case chargebackDate = "chargeback_date"
    }
}

struct GumroadLicenseResponse: Codable {
    let success: Bool
    let purchase: GumroadPurchase?
    let message: String?
}

enum GumroadAPI {
    private static let productID = "szeew2yhbd2U9jdGR-97uQ=="
    private static let verifyURL = URL(string: "https://api.gumroad.com/v2/licenses/verify")!

    static func verify(licenseKey: String, incrementUses: Bool) async throws -> GumroadLicenseResponse {
        var request = URLRequest(url: verifyURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = [
            "product_id": productID,
            "license_key": licenseKey,
            "increment_uses_count": incrementUses ? "true" : "false",
        ]
        request.httpBody = body
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)

        let (data, _): (Data, URLResponse)
        do {
            (data, _) = try await URLSession.shared.data(for: request)
        } catch {
            throw GumroadError.networkError(error)
        }

        let response = try JSONDecoder().decode(GumroadLicenseResponse.self, from: data)
        return response
    }
}
