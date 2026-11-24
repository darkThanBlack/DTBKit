//
//  EmptyCheckable.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation

extension DTB {
    
    /// For object
    public protocol EmptyCheckable {
        
        static func dtb_emptyValue() -> Self
        
        func dtb_isEmpty() -> Bool
    }
    
    /// For number
    public protocol NumberEmptyCheckable: EmptyCheckable {
        
        /// 0
        static func dtb_zeroValue() -> Self
        
        /// != .NaN && != .infinite; Int will always return true.
        func dtb_isFinite() -> Bool
        
        /// == 0
        func dtb_isZero() -> Bool
        
        /// > 0
        func dtb_isPositive() -> Bool
        
        /// < 0
        func dtb_isNegative() -> Bool
    }
}

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
