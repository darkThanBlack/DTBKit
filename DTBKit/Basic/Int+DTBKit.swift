//
//  Int+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Foundation

/// Type convert
///
/// 1. "init" vs. "exactly init"
/// 2. "NaN" vs. nil
/// 3. "high bits to low bits" vs. nil
extension DTBKitWrapper where Base: SignedInteger {
    
    /// 1. Use "exactly init";
    /// 2. Disable "high bits to low bits".
    public var safely: DTBKitWrapper<Int64>? {
        return self.exactlyInt64
    }
    
    ///
    public var exactlyInt: DTBKitWrapper<Int>? {
        return Int(exactly: me)?.dtb
    }
    
    ///
    public var exactlyInt64: DTBKitWrapper<Int64>? {
        return Int64(exactly: me)?.dtb
    }
    
    ///
    public var exactlyFloat: DTBKitWrapper<Float>? {
        return Float(exactly: me)?.dtb
    }
    
    ///
    public var exactlyDouble: DTBKitWrapper<Double>? {
        return Double(exactly: me)?.dtb
    }
    
    ///
    public var exactlyNS: DTBKitWrapper<NSNumber>? {
        if let value = me as? Int {
            return NSNumber(value: value).dtb
        }
        if let value = me as? Int64 {
            return NSNumber(value: value).dtb
        }
        if let value = me as? Int8 {
            return NSNumber(value: value).dtb
        }
        if let value = me as? Int16 {
            return NSNumber(value: value).dtb
        }
        if let value = me as? Int32 {
            return NSNumber(value: value).dtb
        }
        return nil
    }
    
    /// Force convert. Recommended to use ``safe`` convert.
    public var unSafe: DTBKitWrapper<Int64> {
        return Int64(me).dtb
    }
    
    ///
    public var `int`: DTBKitWrapper<Int> {
        return Int(me).dtb
    }
    
    ///
    public var `int64`: DTBKitWrapper<Int64> {
        return Int64(me).dtb
    }
    
    ///
    public var `float`: DTBKitWrapper<Float> {
        return Float(me).dtb
    }
    
    ///
    public var `double`: DTBKitWrapper<Double> {
        return Double(me).dtb
    }
    
    ///
    public var `ns`: DTBKitWrapper<NSNumber> {
        return NSNumber(value: int64.value).dtb
    }
    
    ///
    public var string: DTBKitWrapper<String> {
        return "\(me)".dtb
    }
}

/// Compare
///
/// 比较。
extension DTBKitWrapper where Base == Int64 {
    
    /// Swift.min
    public func `min`(_ value: Int64...) -> Self {
        return Swift.min(value.min() ?? me, me).dtb
    }
    
    /// Swift.max
    public func `max`(_ value: Int64...) -> Self {
        return Swift.max(value.max() ?? me, me).dtb
    }
    
    /// > value ? me : value
    public func greater(_ value: Int64) -> Self {
        return me > value ? self : value.dtb
    }
    
    /// < value ? me : value
    public func less(_ value: Int64) -> Self {
        return me < value ? self : value.dtb
    }
    
    /// me == 0 ? 1 : me
    public func nonZero(_ def: Int64 = 1) -> Self {
        return me == 0 ? def.dtb : self
    }
    
    /// Use math words: "=", ">", ">=", "<", "<=" to compare.
    ///
    /// 合法性检查，使用数学上的不等式符号。
    public func isVaild(_ mathStr: String, to value: Int64) -> Self? {
        return double.isVaild(mathStr, to: Double(value))?.int64()
    }
    
    /// Use math words: "[]", "(]", "[)", "()" to compare.
    ///
    /// 合法性检查，使用数学上的开闭区间符号。
    ///
    /// Sample:
    /// ```
    ///     (1.0).dtb.in("(1, 2]")  // false
    ///     (1.0).dtb.in("[1, 3)")  // true
    ///     (2.0).dtb.in("[)", (1, 3))  // true
    /// ```
    public func isIn(_ mathStr: String, to value: (min: Int64, max: Int64)? = nil) -> Self? {
        if let v = value {
            return double.isIn(mathStr, to: (Double(v.min), Double(v.max)))?.int64()
        } else {
            return double.isIn(mathStr)?.int64()
        }
    }
}

/// Arithmetic: four
///
/// 四则运算。
extension DTBKitWrapper where Base == Int64 {
    
    /// +
    public func plus(_ value: Int64) -> Self {
        return (me + value).dtb
    }
    
    /// -
    public func minus(_ value: Int64) -> Self {
        return (me - value).dtb
    }
    
    /// *
    public func multi(_ value: Int64) -> Self {
        return (me * value).dtb
    }
    
    /// "/"
    public func div(_ value: Double) -> DTBKitWrapper<Double>? {
        guard value.isNaN == false, value != 0 else { return nil }
        return (Double(me) / value).dtb
    }
    
    /// "/"
    public func div(nonNull value: Double) -> DTBKitWrapper<Double> {
        return (Double(me) / value).dtb
    }
}

/// Arithmetic: C
///
/// 基础 C 函数。
extension DTBKitWrapper where Base == Int64 {
    
    ///
    public func abs() -> Self {
        return Swift.abs(me).dtb
    }
}

/// Arithmetic: biz
///
/// 业务扩展。
extension DTBKitWrapper where Base == Int64 {
    
    ///
    public func div100() -> DTBKitWrapper<String>? {
        return div(nonNull: 100.0).string(.dtb.multi.value)
    }
}
