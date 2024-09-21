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

///
extension DTBKitWrapper where Base == NSDecimalNumber {
    
    private func getDecimal(_ value: Any?) -> NSDecimalNumber? {
        if let d = value as? NSDecimalNumber {
            return d
        }
        if let s = value as? String {
            return s.dtb.nsDecimal?.value
        }
        if let v = value as? Double {
            return v.dtb.nsDecimal?.value
        }
        if let i = value as? Int64 {
            return i.dtb.nsDecimal?.value
        }
        return nil
    }
    
    private func getBehavior(_ scale: Int16?, _ rounding: NSDecimalNumber.RoundingMode?) -> NSDecimalNumberHandler {
        if (scale == nil) && (rounding == nil) {
            return DTB.Configuration.shared.decimalBehavior
        } else {
            return NSDecimalNumberHandler(
                roundingMode: rounding ?? DTB.Configuration.shared.decimalBehavior.roundingMode(),
                scale: scale ?? DTB.Configuration.shared.decimalBehavior.scale(),
                raiseOnExactness: false,
                raiseOnOverflow: false,
                raiseOnUnderflow: false,
                raiseOnDivideByZero: false
            )
        }
    }
    
    /// Convert to ``Double``. Return ``nil`` when isNaN.
    public var double: DTBKitWrapper<Double>? {
        return me == NSDecimalNumber.notANumber ? nil : me.doubleValue.dtb
    }
    
    /// Convert to ``String``. Return ``nil`` when isNaN.
    public var string: DTBKitWrapper<String>? {
        return me == NSDecimalNumber.notANumber ? nil : me.stringValue.dtb
    }
    
    /// "+"
    ///
    ///  Note use ``DTB.Configuration.shared.decimalBehavior`` as default value.
    ///
    /// - Parameters:
    ///   - value: NSDecimalNumber / String / Double
    /// - Returns: ``nil`` when isNaN.
    public func plus(_ value: Any?, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self? {
        guard let v = getDecimal(value) else { return nil }
        let result = me.adding(v, withBehavior: getBehavior(scale, rounding))
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
    /// "-"
    /// 
    /// Note use ``DTB.Configuration.shared.decimalBehavior`` as default value.
    /// 
    /// - Parameters:
    ///   - value: NSDecimalNumber / String / Double
    /// - Returns: ``nil`` when isNaN.
    public func minus(_ value: Any, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self? {
        guard let v = getDecimal(value) else { return nil }
        
        let result = me.subtracting(v, withBehavior: getBehavior(scale, rounding))
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
    /// "*"
    ///
    /// Note use ``DTB.Configuration.shared.decimalBehavior`` as default value.
    ///
    /// - Parameters:
    ///   - value: NSDecimalNumber / String / Double
    /// - Returns: ``nil`` when isNaN.
    public func multi(_ value: Any, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self? {
        guard let v = getDecimal(value) else { return nil }
        let result = me.multiplying(by: v, withBehavior: getBehavior(scale, rounding))
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
    /// "/"
    ///
    /// Note use ``DTB.Configuration.shared.decimalBehavior`` as default value.
    ///
    /// - Parameters:
    ///   - value: NSDecimalNumber / String / Double
    /// - Returns: ``nil`` when isNaN.
    public func div(_ value: Any, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self? {
        guard let v = getDecimal(value), 
                v.doubleValue != 0.0 else {
            return nil
        }
        let result = me.multiplying(by: v,withBehavior: getBehavior(scale, rounding))
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
    /// "^"
    ///
    /// Note use ``DTB.Configuration.shared.decimalBehavior`` as default value.
    ///
    /// - Parameters:
    ///   - value: ``Int``.
    /// - Returns: ``nil`` when isNaN.
    public func power(_ value: Int, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self? {
        let result = me.raising(toPower: value,withBehavior: getBehavior(scale, rounding))
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
    /// "* 10^"
    ///
    /// Note use ``DTB.Configuration.shared.decimalBehavior`` as default value.
    ///
    /// - Parameters:
    ///   - value: ``Int16``.
    /// - Returns: ``nil`` when isNaN.
    public func multiPower10(_ value: Int16, scale: Int16? = nil, rounding: NSDecimalNumber.RoundingMode? = nil) -> Self? {
        let result = me.multiplying(byPowerOf10: value,withBehavior: getBehavior(scale, rounding))
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
}
