// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "XProxy",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "XProxy",
            targets: ["XProxy"]
        ),
    ],
    dependencies: [
        .package(path: "../AxLogger/AxLogger"),
        .package(path: "../DarwinCore"),
        .package(path: "../Xcon"),
        .package(path: "../XRuler"),
    ],
    targets: [
        .target(
            name: "XProxy",
            dependencies: [
                .product(name: "AxLogger", package: "AxLogger"),
                .product(name: "DarwinCore", package: "DarwinCore"),
                .product(name: "Xcon", package: "Xcon"),
                .product(name: "XRuler", package: "XRuler"),
            ],
            path: "XProxy",
            exclude: [
                "Info.plist",
                "XProxy.h",
                "mac.xcconfig",
            ]
        ),
    ]
)
