// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SwiftBenchmark",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .executable(
            name: "SwiftBenchmark",
            targets: ["SwiftBenchmark"]
        ),
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "SwiftBenchmark",
            dependencies: []
        ),
    ]
)