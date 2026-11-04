// swift-tools-version: 6.0
//
//  Package.swift
//  SunKit
//
//  Created by Jiawen Sun on 2023/3/28.
//

import PackageDescription

let package = Package(
    name: "SunKit",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(name: "SunCore", targets: ["SunCore"]),
        .library(name: "SunUserInterface", targets: ["SunUserInterface"]),
    ],
    targets: [
        .target(name: "SunCore"),
        .target(name: "SunUserInterface", dependencies: ["SunCore"]),
        .testTarget(name: "SunCoreTests", dependencies: ["SunCore"]),
        .testTarget(name: "SunUserInterfaceTests", dependencies: ["SunUserInterface"]),
    ],
    swiftLanguageModes: [.v6]
)
