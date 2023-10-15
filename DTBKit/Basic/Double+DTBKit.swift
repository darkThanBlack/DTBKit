//
//  CGFloat+DTBKit.swift
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
extension DTBKitWrapper where Base: BinaryFloatingPoint {
    
    /// 1. Use "exactly init";
    /// 2. Disable "high bits to low bits".
    public var safe: DTBKitWrapper<Double>? {
        return self.exactlyDouble
    }
    
    ///
    public var exactlyFloat: DTBKitWrapper<Float>? {
        if let value = me as? Float {
            return Float(exactly: value)?.dtb
        }
        if let value = me as? Double {
            return Float(exactly: value)?.dtb
        }
        return nil
    }
    
    ///
    public var exactlyDouble: DTBKitWrapper<Double>? {
        if let value = me as? Float {
            return Double(exactly: value)?.dtb
        }
        if let value = me as? Double {
            return Double(exactly: value)?.dtb
        }
        return nil
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
    public var exactlyNS: DTBKitWrapper<NSNumber>? {
        if let value = me as? Float {
            return NSNumber(value: value).dtb
        }
        if let value = me as? Double {
            return NSNumber(value: value).dtb
        }
        return nil
    }
    
    /// Force convert. Recommended to use ``safe`` convert.
    public var unSafe: DTBKitWrapper<Double> {
        return Double(me).dtb
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
    public var forceInt: DTBKitWrapper<Int> {
        return Int(me).dtb
    }
    
    ///
    public var forceInt64: DTBKitWrapper<Int64> {
        return Int64(me).dtb
    }
    
    ///
    public func `int`(_ roundRule: FloatingPointRoundingRule? = nil) -> DTBKitWrapper<Int> {
        if let rule = roundRule {
            return Int(me.rounded(rule)).dtb
        }
        return Int(me.rounded()).dtb
    }
    
    ///
    public func `int64`(_ roundRule: FloatingPointRoundingRule? = nil) -> DTBKitWrapper<Int64> {
        if let rule = roundRule {
            return Int64(me.rounded(rule)).dtb
        }
        return Int64(me.rounded()).dtb
    }
    
    ///
    public func rounded(_ roundRule: FloatingPointRoundingRule? = nil) -> Self {
        if let rule = roundRule {
            return DTBKitWrapper(me.rounded(rule))
        }
        return DTBKitWrapper(me.rounded())
    }
    
    ///
    public var `ns`: DTBKitWrapper<NSNumber> {
        return NSNumber(value: double.value).dtb
    }
}

/// String
extension DTBKitWrapper where Base == Double {
    
    ///
    public var string: DTBKitWrapper<String> {
        return "\(me)".dtb
    }
    
    ///
    public func `string`(_ formatter: DTBKitWrapper<NumberFormatter> = NumberFormatter().dtb) -> DTBKitWrapper<String>? {
        return formatter.string(from: exactlyNS?.value)
    }
}

/// Compare
extension DTBKitWrapper where Base == Double {
    
    /// Swift.min
    public func `min`(_ value: Double...) -> Self {
        return ((value + [me]).min() ?? me).dtb
    }
    
    /// Swift.max
    public func `max`(_ value: Double...) -> Self {
        return ((value + [me]).max() ?? me).dtb
    }
    
    /// >= value
    public func setMin(_ value: Double) -> Self {
        return Swift.min(value, me).dtb
    }
    
    /// <= value
    public func setMax(_ value: Double) -> Self {
        return Swift.max(value, me).dtb
    }
    
    /// Use math words: "=", ">", ">=", "<", "<=" to compare
    public func `compare`(_ mathStr: String, to value: Double) -> Self? {
        return check {
            let str = mathStr.trimmingCharacters(in: .whitespaces)
            switch str {
                case "=", "==", "===":  return me == value
                case ">":  return me >  value
                case ">=": return me >= value
                case "<":  return me <  value
                case "<=": return me <= value
                default: return false
            }
        }
    }
    
    /// Use math words: "[]", "(]", "[)", "()" to compare
    ///
    /// Sample:
    /// ```
    ///     (1.0).dtb.in("(1, 2]")  // false
    ///     (1.0).dtb.in("[1, 3)")  // true
    ///     (2.0).dtb.in("[)", (1, 3))  // true
    /// ```
    public func `in`(_ mathStr: String, to value: (min: Double, max: Double)? = nil) -> Self? {
        
        func actual(_ controls: (String, String), values: (Double, Double)) -> Bool {
            switch controls {
                case ("[", "]"):  return (values.0 <= me) && (me <= values.1)
                case ("(", "]"):  return (values.0 <  me) && (me <= values.1)
                case ("[", ")"):  return (values.0 <= me) && (me <  values.1)
                case ("(", ")"):  return (values.0 <  me) && (me <  values.1)
                default:  return false
            }
        }
        return check {
            var str = mathStr.trimmingCharacters(in: .whitespaces)
            
            if let values = value,
               ["[]", "(]", "[)", "()"].contains(str),
               let left = mathStr.first, let right = mathStr.last {
                return actual((String(left), String(right)), values: values)
            }
            
            let leftChar = String(str.removeFirst())
            let rightChar = String(str.removeLast())
            guard let leftStr = str.components(separatedBy: ",").first,
                  let leftValue = Double(leftStr),
                  let rightStr = str.components(separatedBy: ",").last,
                  let rightValue = Double(rightStr) else {
                return false
            }
            return actual((leftChar, rightChar), values: (leftValue, rightValue))
        }
    }
}

/// Arithmetic: four
extension DTBKitWrapper where Base == Double {
    
    /// +
    public func plus(_ value: Double) -> Self {
        return (me + value).dtb
    }
    
    /// +
    public func plus(_ value: Int64) -> Self {
        return (me + Double(value)).dtb
    }
    
    /// -
    public func minus(_ value: Double) -> Self {
        return (me - value).dtb
    }
    
    /// -
    public func minus(_ value: Int64) -> Self {
        return (me - Double(value)).dtb
    }
    
    /// *
    public func multi(_ value: Double) -> Self {
        return (me * value).dtb
    }
    
    /// *
    public func multi(_ value: Int64) -> Self {
        return (me * Double(value)).dtb
    }
    
    /// "/"
    public func div(any value: Int64) -> Self? {
        guard value != 0 else { return nil }
        return (me / Double(value)).dtb
    }
    
    /// "/"
    public func div(any value: Double) -> Self? {
        guard value.isNaN == false, value != 0 else { return nil }
        return (me / value).dtb
    }
    
    /// "/"
    public func div(_ value: Int64) -> Self {
        return (me / Double(value)).dtb
    }
    
    /// "/"
    public func div(_ value: Double) -> Self {
        return (me / value).dtb
    }
}

/// Arithmetic: C
extension DTBKitWrapper where Base == Double {
    
    ///
    public func abs() -> Self {
        return Swift.abs(me).dtb
    }
}

/// Arithmetic: biz
extension DTBKitWrapper where Base == Double {
    
    
    
}
