//
//  OptionalCheckable.swift
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
    
    /// 为 Optional 提供兜底能力。
    ///
    /// 「不可用」由每个类型自己定义：
    /// - `String` / `Array` / `Dictionary` / `Set`：长度 0
    /// - 整数：永远可用（只有 nil 缺失）
    /// - `Float` / `Double`：非有限（NaN / inf）
    ///
    /// - Important: 约束的是 `E` 本身，不是 `Optional<E>`。
    public protocol OptionalCheckable {
        
        /// nil / 无效时使用的值
        static func dtb_defaultValue() -> Self
        
        /// 非 nil 前提下，自身是否不可用
        func dtb_isInvalid() -> Bool
    }
    
    /// 数字额外提供零值与符号语义。
    public protocol NumberCheckable: OptionalCheckable {
        
        func dtb_isZero() -> Bool
        
        func dtb_isPositive() -> Bool
        
        func dtb_isNegative() -> Bool
    }
}

// MARK: - OptionalCheckable

extension String: DTB.OptionalCheckable {
    
    @inline(__always)
    public static func dtb_defaultValue() -> Self { return "" }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return isEmpty }
}

extension Dictionary: DTB.OptionalCheckable {
    
    @inline(__always)
    public static func dtb_defaultValue() -> Self { return [:] }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return isEmpty }
}

extension Array: DTB.OptionalCheckable {
    
    @inline(__always)
    public static func dtb_defaultValue() -> Self { return [] }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return isEmpty }
}

extension Set: DTB.OptionalCheckable {
    
    @inline(__always)
    public static func dtb_defaultValue() -> Self { return [] }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return isEmpty }
}

// MARK: - NumberCheckable

// 整数：只有 nil 缺失，本身没有「无效」态
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

// 浮点：NaN / inf 视为不可用
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
