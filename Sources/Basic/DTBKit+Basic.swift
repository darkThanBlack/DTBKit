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

/// For code coverage.
#if canImport(DTBKit_Core)
@_exported import DTBKit_Core
#endif
#if canImport(DTBKit_Chain)
@_exported import DTBKit_Chain
#endif

extension DTB {
    
    /// Memory dict / App data / etc.
    public static let app = AppManager.shared
    
    /// LLDB Console, replacement for ``Swift.print``
    public static let console = ConsoleManager.shared
    
    /// Default value
    public static let config = ConfigManager.shared
    
    /// Check Optional / Empty / Zero with is / not / or
    public static let check = OptionalChecker()
}

// MARK: - Structable

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

// MARK: - EmptyCheckable

extension String: DTB.EmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self { return "" }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return isEmpty }
}

extension Dictionary: DTB.EmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self { return [:] }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return isEmpty }
}

extension Array: DTB.EmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self { return [] }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return isEmpty }
}

extension Set: DTB.EmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self {return [] }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return isEmpty }
}

// MARK: - NumberCheckable

extension Int: DTB.NumberCheckable {
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return false }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Int8: DTB.NumberCheckable {
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return false }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Int16: DTB.NumberCheckable {
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return false }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Int32: DTB.NumberCheckable {
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return false }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Int64: DTB.NumberCheckable {
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return false }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Float: DTB.NumberCheckable {
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return self.isFinite == false }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Double: DTB.NumberCheckable {
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return self.isFinite == false }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}
