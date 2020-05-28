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
            name: "CFomaSystem",
            pkgConfig: "libfoma" /* Swift package manager (SPM) will look in /usr/lib/pkgconfig, /usr/local/lib/pkgconfig, etc for libfoma.pc
                                  *
                                  * The libfoma.pc file tells SPM where libfoma is installed on the system, as well as
                                  *     what linker and include flags are required for SPM to successfully link against libfoma.
                                  */
        ),
        Target.target(
            name: "Foma",
            dependencies: ["CFomaSystem"]),
        Target.testTarget(
            name: "FomaTests",
            dependencies: ["Foma"]),
    ]
)
