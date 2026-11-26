//
//  DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2023/6/28
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation
import UIKit
import CoreGraphics

/// For code coverage.
#if canImport(DTBKit_Core)
@_exported import DTBKit_Core
#endif

extension DTB {
    
    /// Default value
    public static let config = ConfigManager.shared
}

extension CGSize: DTB.Structable {}

extension CGRect: DTB.Structable {}

extension Date: DTB.Structable {}

extension NSRange: DTB.Structable {}

extension UIEdgeInsets: DTB.Structable {}

extension Dictionary: DTB.Structable {}
