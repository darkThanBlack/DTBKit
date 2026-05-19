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
#if canImport(DTBKit_Theme)
@_exported import DTBKit_Theme
#endif

extension DTB {
    
    /// Default value
    public static let config = ConfigManager.shared
    
    /// Unbox for ``Optional / Empty / Zero``
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

// MARK: - NumberEmptyCheckable

extension Int: DTB.NumberEmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self { return dtb_zeroValue() }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return false }
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isFinite() -> Bool { return true }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Int8: DTB.NumberEmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self { return dtb_zeroValue() }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return false }
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isFinite() -> Bool { return true }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Int16: DTB.NumberEmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self { return dtb_zeroValue() }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return false }
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isFinite() -> Bool { return true }

    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Int32: DTB.NumberEmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self { return dtb_zeroValue() }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return false }
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isFinite() -> Bool { return true }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Int64: DTB.NumberEmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self { return dtb_zeroValue() }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return false }
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isFinite() -> Bool { return true }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Float: DTB.NumberEmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self { return dtb_zeroValue() }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return dtb_isFinite() == false }
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isFinite() -> Bool { return isFinite }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Double: DTB.NumberEmptyCheckable {
    
    @inline(__always)
    public static func dtb_emptyValue() -> Self { return dtb_zeroValue() }
    
    @inline(__always)
    public func dtb_isEmpty() -> Bool { return dtb_isFinite() == false }
    
    @inline(__always)
    public static func dtb_zeroValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isFinite() -> Bool { return isFinite }

    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}
