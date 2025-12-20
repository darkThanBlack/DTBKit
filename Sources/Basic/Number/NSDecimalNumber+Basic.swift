//
//  NSDecimalNumber+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/11/17
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension StaticWrapper where T == NSDecimalNumber {
    
    /// Return NSDecimalNumber.notANumber when fail.
    public func create(_ value: Any) -> NSDecimalNumber {
        if let v = value as? NSDecimalNumber {
            return v
        }
        if let s = value as? String {
            return NSDecimalNumber(string: s)
        }
        if let d = value as? (any BinaryFloatingPoint) {
            return NSDecimalNumber(value: Double(d))
        }
        if let i = value as? (any FixedWidthInteger) {
            return NSDecimalNumber(value: Int64(i))
        }
        return NSDecimalNumber.notANumber
    }
}

///
extension Wrapper where Base == NSDecimalNumber {
    
    private func getDecimal(_ value: Any?) -> NSDecimalNumber? {
        if let d = value as? NSDecimalNumber {
            return d
        }
        if let s = value as? String {
            return s.dtb.nsDecimal()?.value
        }
        if let v = value as? Double {
            return v.dtb.nsDecimal().value
        }
        if let i = value as? Int64 {
            return i.dtb.nsDecimal().value
        }
        return nil
    }
    
    private func getBehavior(_ scale: Int16?, _ rounding: NSDecimalNumber.RoundingMode?) -> NSDecimalNumberHandler {
        if (scale == nil) && (rounding == nil) {
            return DTB.config.decimalBehavior
        } else {
            return NSDecimalNumberHandler(
                roundingMode: rounding ?? DTB.config.decimalBehavior.roundingMode(),
                scale: scale ?? DTB.config.decimalBehavior.scale(),
                raiseOnExactness: false,
                raiseOnOverflow: false,
                raiseOnUnderflow: false,
                raiseOnDivideByZero: false
            )
        }
    }
    
    /// Convert to ``Double``. Return ``nil`` when notANumber.
    @inline(__always)
    public func double() -> Wrapper<Double>? {
        return me == NSDecimalNumber.notANumber ? nil : me.doubleValue.dtb
    }
    
    /// Convert to ``String``. Return ``nil`` when NaN / notANumber.
    @inline(__always)
    public func string() -> Wrapper<String>? {
        return me == NSDecimalNumber.notANumber ? nil : me.stringValue.dtb
    }
    
    /// "+" | 精度加法
    ///
    ///  Use ``DTB.config.decimalBehavior`` as default value when scale && rounding is nil.
    ///
    ///  当 scale 和 rounding 都为 nil 时使用 ``DTB.config.decimalBehavior`` 作为默认值。
    ///
    /// - Parameters:
    /// - value: Support NSDecimalNumber / String / Double / Int64.
    public func plus(_ value: Any, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self {
        return me.adding(.dtb.create(value), withBehavior: getBehavior(scale, rounding)).dtb
    }
    
    /// "-" | 精度减法
    ///
    ///  Use ``DTB.config.decimalBehavior`` as default value when scale && rounding is nil.
    ///
    ///  当 scale 和 rounding 都为 nil 时使用 ``DTB.config.decimalBehavior`` 作为默认值。
    /// 
    /// - Parameters:
    /// - value: Support NSDecimalNumber / String / Double / Int64.
    public func minus(_ value: Any, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self {
        return me.subtracting(.dtb.create(value), withBehavior: getBehavior(scale, rounding)).dtb
    }
    
    /// "*" | 精度乘法
    ///
    ///  Use ``DTB.config.decimalBehavior`` as default value when scale && rounding is nil.
    ///
    ///  当 scale 和 rounding 都为 nil 时使用 ``DTB.config.decimalBehavior`` 作为默认值。
    ///
    /// - Parameters:
    /// - value: Support NSDecimalNumber / String / Double / Int64.
    /// - Returns: ``nil`` when isNaN. | 会过滤 notANumber
    public func multi(_ value: Any, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self {
        return me.multiplying(by: .dtb.create(value), withBehavior: getBehavior(scale, rounding)).dtb
    }
    
    /// "/" | 精度除法
    ///
    ///  Use ``DTB.config.decimalBehavior`` as default value when scale && rounding is nil.
    ///
    ///  当 scale 和 rounding 都为 nil 时使用 ``DTB.config.decimalBehavior`` 作为默认值。
    ///
    /// - Parameters:
    /// - value: Support NSDecimalNumber / String / Double / Int64.
    public func div(_ value: Any, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self {
        return me.dividing(by: .dtb.create(value), withBehavior: getBehavior(scale, rounding)).dtb
    }
    
    /// "^" | 精度 me 的 value 次方
    ///
    ///  Use ``DTB.config.decimalBehavior`` as default value when scale && rounding is nil.
    ///
    ///  当 scale 和 rounding 都为 nil 时使用 ``DTB.config.decimalBehavior`` 作为默认值。
    ///
    /// - Parameters:
    ///   - value: ``Int``.
    public func power(_ value: Int, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self {
        return me.raising(toPower: value, withBehavior: getBehavior(scale, rounding)).dtb
    }
    
    /// "* 10^" | 精度 10 的幂次方
    ///
    ///  Use ``DTB.config.decimalBehavior`` as default value when scale && rounding is nil.
    ///
    ///  当 scale 和 rounding 都为 nil 时使用 ``DTB.config.decimalBehavior`` 作为默认值。
    ///
    /// - Parameters:
    ///   - value: ``Int16``.
    /// - Returns: ``nil`` when isNaN. | 会过滤 notANumber
    public func multiPower10(_ value: Int16, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self {
        return me.multiplying(byPowerOf10: value, withBehavior: getBehavior(scale, rounding)).dtb
    }
}
