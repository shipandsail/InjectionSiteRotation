// swift-tools-version:5.7
import PackageDescription
let package = Package(
    name: "InjectionSiteRotation",
    platforms: [.iOS(.v15), .macOS(.v12), .watchOS(.v9)],
    products: [.library(name: "InjectionSiteRotation", targets: ["InjectionSiteRotation"])],
    targets: [
        .target(name: "InjectionSiteRotation"),
        .testTarget(name: "InjectionSiteRotationTests", dependencies: ["InjectionSiteRotation"]),
    ]
)
