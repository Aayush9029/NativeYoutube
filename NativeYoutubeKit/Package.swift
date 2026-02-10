// swift-tools-version: 5.10
import PackageDescription

extension Target.Dependency {
    // Internal Libraries
    static let ui: Self = "UI"
    static let assets: Self = "Assets"
    static let models: Self = "Models"
    static let apiClient: Self = "APIClient"
    static let shared: Self = "Shared"
    static let clients: Self = "Clients"

    // External Dependencies
    static let swiftDependencies: Self = .product(name: "Dependencies", package: "swift-dependencies")
    static let swiftDependenciesMacros: Self = .product(name: "DependenciesMacros", package: "swift-dependencies")
    static let identifiedCollections: Self = .product(name: "IdentifiedCollections", package: "swift-identified-collections")
    static let swiftSharing: Self = .product(name: "Sharing", package: "swift-sharing")
    static let youTubeKit: Self = .product(name: "YouTubeKit", package: "YouTubeKit")
    static let customDump: Self = .product(name: "CustomDump", package: "swift-custom-dump")
}

let package = Package(
    name: "NativeYoutubeKit",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "UI", targets: ["UI"]),
        .library(name: "Assets", targets: ["Assets"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "Shared", targets: ["Shared"]),
        .library(name: "Clients", targets: ["Clients"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.11.0"),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "1.1.1"),
        .package(url: "https://github.com/pointfreeco/swift-sharing.git", from: "2.7.4"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.3.0"),
        .package(url: "https://github.com/alexeichhorn/YouTubeKit.git", from: "0.4.3")
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: [
                .assets,
                .models,
                .shared
            ]
        ),
        .target(
            name: "Assets",
            resources: [.process("Resources")]
        ),
        .target(
            name: "Models",
            dependencies: [
                .shared
            ]
        ),
        .target(
            name: "APIClient",
            dependencies: [
                .models,
                .shared,
                .swiftDependencies,
                .swiftDependenciesMacros
            ]
        ),
        .target(
            name: "Shared",
            dependencies: [
                .swiftSharing,
                .youTubeKit,
                .swiftDependencies,
                .swiftDependenciesMacros
            ]
        ),
        .target(
            name: "Clients",
            dependencies: [
                .apiClient,
                .models,
                .shared,
                .swiftDependencies,
                .swiftDependenciesMacros
            ]
        ),
        .testTarget(
            name: "ModelsTests",
            dependencies: [
                .models,
                .customDump
            ]
        ),
        .testTarget(
            name: "APIClientTests",
            dependencies: [
                .apiClient,
                .models,
                .swiftDependencies,
                .customDump
            ]
        ),
        .testTarget(
            name: "ClientsTests",
            dependencies: [
                .clients,
                .apiClient,
                .models,
                .shared,
                .swiftDependencies,
                .customDump
            ]
        ),
        .testTarget(
            name: "APIIntegrationTests",
            dependencies: [
                .apiClient,
                .models,
                .shared
            ]
        )
    ]
)
