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
    
    ///
    private func anyString(_ value: Any) -> String? {
        if let v = value as? Double {
            return "\(v)"
        }
        if let s = value as? String, s.isEmpty == false {
            return s
        }
        return nil
    }
    
    /// +
    public func plus(_ value: Any, behavior: NSDecimalNumberHandler?) -> Self? {
        guard let target = anyString(value) else { return nil }
        return me.adding(NSDecimalNumber(string: target), withBehavior: behavior).dtb
    }
    
    /// "+", Use ``DTB.Performance.decimalBehavior``
    public func plus(_ value: Any, scale: Int16 = 2, rounding: NSDecimalNumber.RoundingMode = .plain) -> Self? {
        guard let target = anyString(value) else { return nil }
        let behavior = ((scale == 2) && (rounding == .plain)) ? DTB.Performance.decimalBehavior : NSDecimalNumberHandler(roundingMode: rounding, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return me.adding(NSDecimalNumber(string: target), withBehavior: behavior).dtb
    }
    
    /// -
    public func minus(_ value: Any, behavior: NSDecimalNumberHandler?) -> Self? {
        guard let target = anyString(value) else { return nil }
        return me.subtracting(NSDecimalNumber(string: target), withBehavior: behavior).dtb
    }
    
    /// "-", Use ``DTB.Performance.decimalBehavior``
    public func minus(_ value: Any, scale: Int16 = 2, rounding: NSDecimalNumber.RoundingMode = .plain) -> Self? {
        guard let target = anyString(value) else { return nil }
        let behavior = ((scale == 2) && (rounding == .plain)) ? DTB.Performance.decimalBehavior : NSDecimalNumberHandler(roundingMode: rounding, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return me.subtracting(NSDecimalNumber(string: target), withBehavior: behavior).dtb
    }
    
    /// *
    public func multi(_ value: Any, behavior: NSDecimalNumberHandler?) -> Self? {
        guard let target = anyString(value) else { return nil }
        return me.multiplying(by: NSDecimalNumber(string: target), withBehavior: behavior).dtb
    }
    
    /// "*", Use ``DTB.Performance.decimalBehavior``
    public func multi(_ value: Any, scale: Int16 = 2, rounding: NSDecimalNumber.RoundingMode = .plain) -> Self? {
        guard let target = anyString(value) else { return nil }
        let behavior = ((scale == 2) && (rounding == .plain)) ? DTB.Performance.decimalBehavior : NSDecimalNumberHandler(roundingMode: rounding, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return me.multiplying(by: NSDecimalNumber(string: target), withBehavior: behavior).dtb
    }
    
    /// /
    public func div(_ value: Any, behavior: NSDecimalNumberHandler?) -> Self? {
        guard let target = anyString(value), Double(target) != 0.0 else { return nil }
        return me.multiplying(by: NSDecimalNumber(string: target), withBehavior: behavior).dtb
    }
    
    /// "/", Use ``DTB.Performance.decimalBehavior``
    public func div(_ value: Any, scale: Int16 = 2, rounding: NSDecimalNumber.RoundingMode = .plain) -> Self? {
        guard let target = anyString(value), Double(target) != 0.0 else { return nil }
        let behavior = ((scale == 2) && (rounding == .plain)) ? DTB.Performance.decimalBehavior : NSDecimalNumberHandler(roundingMode: rounding, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return me.multiplying(by: NSDecimalNumber(string: target), withBehavior: behavior).dtb
    }
    
    /// ^
    public func power(_ value: Int, behavior: NSDecimalNumberHandler?) -> Self? {
        return me.raising(toPower: value, withBehavior: behavior).dtb
    }
    
    /// "^", Use ``DTB.Performance.decimalBehavior``
    public func power(_ value: Int, scale: Int16 = 2, rounding: NSDecimalNumber.RoundingMode = .plain) -> Self? {
        let behavior = ((scale == 2) && (rounding == .plain)) ? DTB.Performance.decimalBehavior : NSDecimalNumberHandler(roundingMode: rounding, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return me.raising(toPower: value, withBehavior: behavior).dtb
    }
    
    /// * 10^
    public func multiPower10(_ value: Int16, behavior: NSDecimalNumberHandler?) -> Self? {
        return me.multiplying(byPowerOf10: value, withBehavior: behavior).dtb
    }
    
    /// "* 10^", Use ``DTB.Performance.decimalBehavior``
    public func multiPower10(_ value: Int16, scale: Int16 = 2, rounding: NSDecimalNumber.RoundingMode = .plain) -> Self? {
        let behavior = ((scale == 2) && (rounding == .plain)) ? DTB.Performance.decimalBehavior : NSDecimalNumberHandler(roundingMode: rounding, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return me.multiplying(byPowerOf10: value, withBehavior: behavior).dtb
    }
}
