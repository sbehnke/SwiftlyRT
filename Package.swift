// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftlyRT",
	defaultLocalization: "en",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftlyRT",
            targets: ["SwiftlyRT"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
		.package(url: "https://github.com/jpsim/Yams.git", from: "5.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftlyRT",
            dependencies: ["Yams"],
			path: "SwiftlyRT/Engine"
            ),
        .testTarget(
            name: "SwiftlyRTTests",
            dependencies: ["SwiftlyRT"],
			path: "SwiftlyRTTests",
			exclude: [
				"Info.plist",
			],
            resources: [
                .copy("Resources/triangles.obj"),
                .copy("Resources/cube.obj"),
            ],
            swiftSettings: [
                .define("PACKAGE_BUILD")
            ]
        ),
    ]
)
