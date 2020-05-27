// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Foma",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        Product.library(
            name: "Foma",
            targets: ["Foma"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: "https://github.com/dowobeha/CFomaSystem.git", from: "0.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        Target.systemLibrary(
            name: "CFomaSystem"),
        Target.target(
            name: "Foma",
            dependencies: ["CFomaSystem"],
            linkerSettings: [LinkerSetting.unsafeFlags(["-Xlinker", "-L/usr/local/lib"])]), //[LinkerSetting.linkedLibrary("/usr/local/lib/libfoma.a")]),
        Target.testTarget(
            name: "FomaTests",
            dependencies: ["Foma"],
            linkerSettings: [LinkerSetting.unsafeFlags(["-Xlinker", "-L/usr/local/lib"])]), //[LinkerSetting.linkedLibrary("/usr/local/lib/libfoma.a")]),
    ]
)
