// swift-tools-version: 5.10
import PackageDescription

extension Target.Dependency {
    // Internal Libraries
    static let ui: Self = "UI"
    static let assets: Self = "Assets"
    static let models: Self = "Models"
    static let apiClient: Self = "APIClient"
    static let shared: Self = "Shared"

    // External Dependencies
    static let swiftDependencies: Self = .product(name: "Dependencies", package: "swift-dependencies")
    static let swiftDependenciesMacros: Self = .product(name: "DependenciesMacros", package: "swift-dependencies")
    static let identifiedCollections: Self = .product(name: "IdentifiedCollections", package: "swift-identified-collections")
    static let sfSafeSymbols: Self = .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
    static let httpTypes: Self = .product(name: "HTTPTypes", package: "swift-http-types")
    static let httpTypesFoundation: Self = .product(name: "HTTPTypesFoundation", package: "swift-http-types")
    static let pow: Self = .product(name: "Pow", package: "Pow")
}

let package = Package(
    name: "NativeYoutubeKit",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "UI", targets: ["UI"]),
        .library(name: "Assets", targets: ["Assets"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "Shared", targets: ["Shared"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.7.0"),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "1.1.0"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols", from: "5.4.0"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.4.1"),
        .package(url: "https://github.com/EmergeTools/Pow", from: "1.0.5")
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: [
                .assets,
                .models,
                .shared,
                .sfSafeSymbols,
                .pow
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
                .swiftDependenciesMacros,
                .httpTypes,
                .httpTypesFoundation
            ]
        ),
        .target(
            name: "Shared",
            dependencies: [
                .identifiedCollections,
                .swiftDependencies,
                .swiftDependenciesMacros
            ]
        )
    ]
)
