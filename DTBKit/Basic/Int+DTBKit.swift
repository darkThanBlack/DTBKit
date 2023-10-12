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
    public var safe: DTBKitWrapper<Int64>? {
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
    public var ns: DTBKitWrapper<NSNumber>? {
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
    public var string: DTBKitWrapper<String> {
        return "\(me)".dtb
    }
}

/// Compare
extension DTBKitWrapper where Base == Int64 {
    
    /// Swift.min
    public func `min`(_ value: Int64...) -> Self {
        return ((value + [me]).min() ?? me).dtb
    }
    
    /// Swift.min
    public func `min`(_ value: Double...) -> DTBKitWrapper<Double> {
        return ((value + [Double(me)]).min() ?? Double(me)).dtb
    }
    
    /// Swift.max
    public func `max`(_ value: Int64...) -> Self {
        return ((value + [me]).max() ?? me).dtb
    }
    
    /// Swift.max
    public func `max`(_ value: Double...) -> DTBKitWrapper<Double> {
        return ((value + [Double(me)]).max() ?? Double(me)).dtb
    }
    
    /// >= value
    public func setMin(_ value: Int64) -> Self {
        return Swift.min(value, me).dtb
    }
    
    /// >= value
    public func setMin(_ value: Double) -> DTBKitWrapper<Double> {
        return Swift.min(value, Double(me)).dtb
    }
    
    /// <= value
    public func setMax(_ value: Int64) -> Self {
        return Swift.max(value, me).dtb
    }
    
    /// <= value
    public func setMax(_ value: Double) -> DTBKitWrapper<Double> {
        return Swift.max(value, Double(me)).dtb
    }
    
    /// 0 -> def
    public func nonZero(_ def: Int64 = 1) -> Self {
        guard me != 0 else {
            return (def == 0 ? 1 : def).dtb
        }
        return self
    }
    
    /// Use math words: "=", ">", ">=", "<", "<=" to compare
    public func `compare`(_ mathStr: String, to value: Int64) -> Self? {
        return check {
            switch mathStr {
                case "=", "==", "===":  return me == value
                case ">":  return me > value
                case ">=": return me >= value
                case "<":  return me < value
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
    public func `in`(_ mathStr: String, to value: (min: Int64, max: Int64)? = nil) -> Self? {
        
        func actual(_ controls: (String, String), values: (Int64, Int64)) -> Bool {
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
                  let leftValue = Int64(leftStr),
                  let rightStr = str.components(separatedBy: ",").last,
                  let rightValue = Int64(rightStr) else {
                return false
            }
            return actual((leftChar, rightChar), values: (leftValue, rightValue))
        }
    }
}

/// Arithmetic: four
extension DTBKitWrapper where Base == Int64 {
    
    /// +
    public func plus(_ value: Int64) -> Self {
        return (me + value).dtb
    }
    
    /// +
    public func plus(_ value: Double) -> DTBKitWrapper<Double> {
        return (Double(me) + value).dtb
    }
    
    /// -
    public func minus(_ value: Int64) -> Self {
        return (me - value).dtb
    }
    
    /// -
    public func minus(_ value: Double) -> DTBKitWrapper<Double> {
        return (Double(me) - value).dtb
    }
    
    /// *
    public func multi(_ value: Int64) -> Self {
        return (me * value).dtb
    }
    
    /// *
    public func multi(_ value: Double) -> DTBKitWrapper<Double> {
        return (Double(me) * value).dtb
    }
    
    /// "/"
    public func div(_ value: Int64) -> DTBKitWrapper<Double>? {
        guard value != 0 else { return nil }
        return (Double(me) / Double(value)).dtb
    }
    
    /// "/"
    public func div(_ value: Double) -> DTBKitWrapper<Double>? {
        guard value != 0 else { return nil }
        return (Double(me) / value).dtb
    }
    
    /// "/"
    public func div(nonNull value: Int64) -> DTBKitWrapper<Double> {
        return (Double(me) / Double(value)).dtb
    }
    
    /// "/"
    public func div(nonNull value: Double) -> DTBKitWrapper<Double> {
        return (Double(me) / value).dtb
    }
}

/// Arithmetic: C
extension DTBKitWrapper where Base == Int64 {
    
    ///
    public func abs() -> Self {
        return Swift.abs(me).dtb
    }
}

/// Arithmetic: biz
extension DTBKitWrapper where Base == Int64 {
    
    
    
}
