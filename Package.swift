// swift-tools-version:5.3

/**
 Manifest file for Swift Package Manager. This file defines our Swift Package for customers to install our SDK modules into their app. 

 Resources to learn more about this file:
 * https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html
 * https://github.com/apple/swift-package-manager/blob/main/Documentation/Usage.md
 */

import PackageDescription
import Foundation

// Swift Package Manager products are public-facing modules that developers can install into their app. 
// All .library() products will be visible to customers in Xcode when they install our SDK into their app.
// Therefore, it's important that we only expose modules that we want customers to use. Internal modules should not be included in this array.
var products: [PackageDescription.Product] = [
    .library(name: "DataPipelines2", targets: ["CioDataPipelines2"]),
    .library(name: "MessagingPushAPN2", targets: ["CioMessagingPushAPN2"]),
//    .library(name: "MessagingPushFCM", targets: ["CioMessagingPushFCM"]),
//    .library(name: "MessagingInApp", targets: ["CioMessagingInApp"])
]

// When we execute the automated test suite, we use tools to determine the code coverage of our tests. 
// Xcode generates this code coverage report for us, for all of the products in this Package.swift file. 
// It's important that we track the test code coverage of our internal modules, but we don't want to expose internal modules to customers when they install our SDK. 
// Therefore, we dynamically modify the products array to include the internal modules only when executing the test suite and generating code coverage reports.
//if (ProcessInfo.processInfo.environment["CI"] != nil) { // true if running on a CI machine. Important this is false for a customer trying to install our SDK on their machine. 
//    // append all internal modules to the products array.
//    products.append(.library(name: "InternalCommon", targets: ["CioInternalCommon2"]))
//    products.append(.library(name: "Migration", targets: ["CioTrackingMigration2"]))
//}

let package = Package(
    name: "Customer.io2",
    platforms: [
        .iOS(.v13)
    ],
    products: products,
    dependencies: [
        // Help for the format of declaring SPM dependencies:
        // https://web.archive.org/web/20220525200227/https://www.timc.dev/posts/understanding-swift-packages/
        //
        // Update to exact version until wrapper SDKs become part of testing pipeline.
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", "8.7.0"..<"12.0.0"),
        

        // Make sure the version number is same for DataPipelines cocoapods.
        .package(name: "CioAnalytics2", path: "Submodules/cdp-analytics-swift2"),
    ],
    targets: [ 
        // Common - Code used by multiple modules in the SDK project.
        // this module is *not* exposed to the public. It's used internally. 
        .target(name: "CioInternalCommon2",
                path: "Sources/Common"),
//        .testTarget(name: "CommonTests",
//                    dependencies: ["CioInternalCommon2", "SharedTests"],
//                    path: "Tests/Common"),
        // Migration
        // this module handles Journeys tasks migration to Datapipeline.
        .target(name: "CioTrackingMigration2",
                dependencies: ["CioInternalCommon2"],
                path: "Sources/Migration"),
//        .testTarget(name: "MigrationTests",
//                    dependencies: ["CioTrackingMigration2", "SharedTests"],
//                    path: "Tests/Migration"),
//        // shared code dependency that other test targets use. 
//        .target(name: "SharedTests",
//                dependencies: ["CioInternalCommon2"],
//                path: "Tests/Shared",
//                resources: [
//                    .copy("SampleDataFiles") // static files that are used in test functions.
//                ]),

        // Messaging Push 
        .target(name: "CioMessagingPush2",
                dependencies: ["CioInternalCommon2"],
                path: "Sources/MessagingPush"),
//        .testTarget(name: "MessagingPushTests",
//                    dependencies: ["CioMessagingPush2", "SharedTests"],
//                    path: "Tests/MessagingPush"),
        
        // Data Pipeline
        .target(name: "CioDataPipelines2",
                dependencies: ["CioInternalCommon2", "CioTrackingMigration2", 
                    .product(name: "CioAnalytics2", package: "CioAnalytics2")],
                path: "Sources/DataPipeline", resources: [
                    .process("Resources/PrivacyInfo.xcprivacy"),
                ]),
//        .testTarget(name: "DataPipelineTests",
//                    dependencies: ["CioDataPipelines2", "SharedTests"],
//                    path: "Tests/DataPipeline"),

        // APN
        .target(name: "CioMessagingPushAPN2",
                dependencies: ["CioMessagingPush2"],
                path: "Sources/MessagingPushAPN",
                resources: [
                    .process("Resources/PrivacyInfo.xcprivacy"),
                ]),
//        .testTarget(name: "MessagingPushAPNTests",
//                    dependencies: ["CioMessagingPushAPN2", "SharedTests"],
//                    path: "Tests/MessagingPushAPN"),
//        // FCM 
//        .target(name: "CioMessagingPushFCM",
//                dependencies: ["CioMessagingPush2", .product(name: "FirebaseMessaging", package: "Firebase")],
//                path: "Sources/MessagingPushFCM",
//                resources: [
//                    .process("Resources/PrivacyInfo.xcprivacy"),
//                ]),
//        .testTarget(name: "MessagingPushFCMTests",
//                    dependencies: ["CioMessagingPushFCM", "SharedTests"],
//                    path: "Tests/MessagingPushFCM"),
//
//        // Messaging in-app
//        .target(name: "CioMessagingInApp",
//                dependencies: ["CioInternalCommon2"],
//                path: "Sources/MessagingInApp",
//                resources: [
//                    .process("Resources/PrivacyInfo.xcprivacy"),
//                ]),
//        .testTarget(name: "MessagingInAppTests",
//                    dependencies: ["CioMessagingInApp", "SharedTests"],
//                    path: "Tests/MessagingInApp"),
    ]
)
