//
//  NSBundle+Extensions.swift
//  CometChatSnackBoard
//
//  Created by Timothy Moose on 8/8/16.
//  Copyright © 2016 SwiftKick Mobile LLC. All rights reserved.
//

import Foundation

private class BundleToken {}

extension Bundle {
    // This is copied method from SPM generated Bundle.module for CocoaPods support
    static func sm_frameworkBundle() -> Bundle {

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.module.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleToken.self).resourceURL,

            // For command-line tools.
            Bundle.module.bundleURL,
        ]

        let bundleNames = [
            // For Swift Package Manager
            "CometChatSnackBoard_CometChatSnackBoard",

            // For Carthage
            "CometChatSnackBoard",
        ]

        for bundleName in bundleNames {
            for candidate in candidates {
                let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
                if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                    return bundle
                }
            }
        }

        // Return whatever bundle this code is in as a last resort.
        return Bundle(for: BundleToken.self)
    }
}
