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
#if canImport(DTBKit_Chain)
@_exported import DTBKit_Chain
#endif

extension DTB {
    
    /// Default value
    public static let config = ConfigManager.shared
}

extension CGSize: Structable {}

extension CGRect: Structable {}

extension Date: Structable {}

extension NSRange: Structable {}

extension UIEdgeInsets: Structable {}

extension Dictionary: Structable {}
