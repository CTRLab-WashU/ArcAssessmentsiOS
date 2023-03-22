// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Arc",
    defaultLocalization: "en",
    platforms: [
        // Add support for all platforms starting from a specific version.
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Arc",
            targets: ["Arc"])
    ],
    targets: [

        .target(
            name: "Arc",
	   path: "Arc",
	   exclude:["Info.plist", "../SampleApp"],
	   resources: [
                .process("Resources"),
            ]),
	.testTarget(name:"ArcTests",
                dependencies: ["Arc"],
                path: "ArcTests",
                exclude:["Info.plist", "../SampleApp"])
    ]
)
