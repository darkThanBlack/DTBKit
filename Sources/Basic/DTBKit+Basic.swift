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

extension DTB {
    
    /// Memory dict / App data / etc.
    public static let app = AppManager.shared
    
    /// LLDB Console, replacement for ``Swift.print``
    public static let console = ConsoleManager.shared
    
    /// Default value
    public static let config = DTB.Configuration.shared
}

extension Int: Structable {}

extension Int8: Structable {}

extension Int16: Structable {}

extension Int32: Structable {}

extension Int64: Structable {}

extension Float: Structable {}

extension Double: Structable {}

extension String: Structable {}

extension CGFloat: Structable {}

extension Decimal: Structable {}

extension Array: Structable {}

extension Data: Structable {}

extension UIFont.Weight: Structable {}
