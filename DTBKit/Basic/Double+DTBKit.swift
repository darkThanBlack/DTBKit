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
/// 1. Use exactly init.
/// 2. "NaN" value will be nil.
/// 3. Convert high bits to low bits will be nil.
/// 4. Not allow get low bits value.
extension DTBKitWrapper where Base: BinaryFloatingPoint {
    
    /// Default type, use it to start extra action.
    ///
    /// Sample: ``Float(1.0).dtb.safe?.max(2).value``
    public var safe: DTBKitWrapper<Double>? {
        return self.double
    }
    
    ///
    public var `float`: DTBKitWrapper<Float>? {
        if let value = me as? Float {
            return Float(exactly: value)?.dtb
        }
        if let value = me as? Double {
            return Float(exactly: value)?.dtb
        }
        return nil
    }
    
    ///
    public var `double`: DTBKitWrapper<Double>? {
        if let value = me as? Float {
            return Double(exactly: value)?.dtb
        }
        if let value = me as? Double {
            return Double(exactly: value)?.dtb
        }
        return nil
    }
    
    ///
    public var `int`: DTBKitWrapper<Int>? {
        return Int(exactly: me)?.dtb
    }
    
    ///
    public var `int64`: DTBKitWrapper<Int64>? {
        return Int64(exactly: me)?.dtb
    }
    
    ///
    public var ns: DTBKitWrapper<NSNumber>? {
        if let value = me as? Float {
            return NSNumber(value: value).dtb
        }
        if let value = me as? Double {
            return NSNumber(value: value).dtb
        }
        return nil
    }
    
    ///
    public var string: DTBKitWrapper<String> {
        return "\(me)".dtb
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
    public func bigger(than value: Double) -> Self {
        return Swift.min(value, me).dtb
    }
    
    /// <= value
    public func smaller(than value: Double) -> Self {
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

