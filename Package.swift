// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "LocalizeKit",
        platforms: [
            .iOS(.v9),
        ],
        products: [
            // Products define the executables and libraries produced by a package, and make them visible to other packages.
            .library(
                    name: "LocalizeKit",
                    targets: ["LocalizeKit"]),
        ],
        targets: [
            .target(
               name: "LocalizeKitC",
               dependencies: [],
               cSettings: [
                  .headerSearchPath("include"),
               ]
            ),
            .target(
                    name: "LocalizeKit",
                    dependencies: ["LocalizeKitC"]),
            .testTarget(
                    name: "LocalizeKitTests",
                    dependencies: ["LocalizeKit"]),
        ]
)
