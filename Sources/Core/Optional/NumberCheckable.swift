//
//  NumberCheckable.swift
//  DTBKit
//
//  Created by moonShadow on 2026/11/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Foundation

extension DTB {
    
    ///
    public protocol NumberCheckable: OptionalCheckable {
        
        func dtb_isZero() -> Bool
        
        func dtb_isPositive() -> Bool
        
        func dtb_isNegative() -> Bool
    }
}

// MARK: -

extension Int: DTB.NumberCheckable {
    
    @inline(__always)
    public static func dtb_defaultValue() -> Self { return 0 }
    
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
    public static func dtb_defaultValue() -> Self { return 0 }
    
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
    public static func dtb_defaultValue() -> Self { return 0 }
    
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
    public static func dtb_defaultValue() -> Self { return 0 }
    
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
    public static func dtb_defaultValue() -> Self { return 0 }
    
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
    public static func dtb_defaultValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return !isFinite }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}

extension Double: DTB.NumberCheckable {
    
    @inline(__always)
    public static func dtb_defaultValue() -> Self { return 0 }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return !isFinite }
    
    @inline(__always)
    public func dtb_isZero() -> Bool { return self == 0 }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool { return self > 0 }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool { return self < 0 }
}
