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
/// 基础类型转换。
///
/// 1. "init" vs. "exactly init"
/// 2. "NaN" vs. nil
/// 3. "high bits to low bits" vs. nil
extension DTBKitWrapper where Base: BinaryFloatingPoint {
    
    /// 1. Use "exactly init";
    /// 2. Disable "high bits to low bits".
    public var safely: DTBKitWrapper<Double>? {
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
    
    /// Force convert.
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
///
/// 字符串处理。
extension DTBKitWrapper where Base == Double {
    
    /// Convert to string.
    ///
    /// 转字符串。
    public var string: DTBKitWrapper<String> {
        return "\(me)".dtb
    }
    
    /// Convert to string with numberFormatter.
    ///
    /// 格式化字符串。
    ///
    /// For example:
    /// ```
    ///     /// Use preset formatter
    ///     let a = 2.1.dtb.toString(.dtb.CNY)?.value
    ///
    ///     /// Custom formatter
    ///     let b = 2.dtb.double.toString(NumberFormatter().dtb.decimal(2).rounded(.halfDown).prefix("¥", negative: "-¥").value)
    /// ```
    public func toString(_ formatter: NumberFormatter) -> DTBKitWrapper<String>? {
        return formatter.dtb.string(from: ns.value)
    }
    
    /// Convert to NSDecimalNumber with behavior.
    ///
    /// 开始高精度处理。
    public func toDecimal() -> DTBKitWrapper<NSDecimalNumber> {
        return NSDecimalNumber(string: "\(me)").dtb
    }
}

/// Compare
///
/// 比较。
extension DTBKitWrapper where Base == Double {
    
    /// Swift.min
    public func `min`(_ value: Double...) -> Self where Base == Double {
        return ((value + [me]).min() ?? me).dtb
    }
    
    /// Swift.max
    public func `max`(_ value: Double...) -> Self where Base == Double {
        return ((value + [me]).max() ?? me).dtb
    }
    
    /// >= value ? self : value
    public func greater(_ value: Double) -> Self {
        return me > value ? self : value.dtb
    }
    
    /// <= value ? self : value
    public func less(_ value: Double) -> Self {
        return me < value ? self : value.dtb
    }
    
    /// me == 0 ? 1 : me
    public func nonZero(_ def: Double = 1.0) -> Self {
        return me == 0 ? def.dtb : self
    }
    
    /// Use math words: "=", ">", ">=", "<", "<=" to compare.
    ///
    /// 合法性检查，使用数学上的不等式符号。
    ///
    /// Sample:
    /// ```
    ///     let a = 1.0.dtb.isVaild("<", to: 3)?.value   // a == 1
    ///     let b = 2.0.dtb.isVaild("==", to: 1)?.value  // b == nil
    /// ```
    public func isVaild(_ mathStr: String, to value: Double) -> Bool {
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
    
    /// Use math words: "[]", "(]", "[)", "()" to compare.
    ///
    /// 合法性检查，允许使用数学上的开闭区间符号。
    ///
    /// Sample:
    /// ```
    ///     (1.0).dtb.in("(1, 2]")  // false
    ///     (1.0).dtb.in("[1, 3)")  // true
    ///     (2.0).dtb.in("[)", (1, 3))  // true
    /// ```
    public func isIn(_ mathStr: String, to value: (min: Double, max: Double)? = nil) -> Bool? {
        
        func actual(_ controls: (String, String), values: (Double, Double)) -> Bool {
            switch controls {
                case ("[", "]"):  return (values.0 <= me) && (me <= values.1)
                case ("(", "]"):  return (values.0 <  me) && (me <= values.1)
                case ("[", ")"):  return (values.0 <= me) && (me <  values.1)
                case ("(", ")"):  return (values.0 <  me) && (me <  values.1)
                default:  return false
            }
        }
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

/// Arithmetic: four
///
/// 四则运算。
extension DTBKitWrapper where Base == Double {
    
    /// +
    public func plus(_ value: Double) -> Self {
        return (me + value).dtb
    }
    
    /// -
    public func minus(_ value: Double) -> Self {
        return (me - value).dtb
    }
    
    /// *
    public func multi(_ value: Double) -> Self {
        return (me * value).dtb
    }
    
    /// "/"
    public func div(_ value: Double) -> Self? {
        guard value.isNaN == false, value != 0 else { return nil }
        return (me / value).dtb
    }
    
    /// "/"
    public func div(nonNull value: Double) -> Self {
        return (me / value).dtb
    }
}

/// Arithmetic: C
///
/// 基础 C 函数。
extension DTBKitWrapper where Base == Double {
    
    ///
    public func abs() -> Self {
        return Swift.abs(me).dtb
    }
}

/// Arithmetic: biz
///
/// 业务扩展。
extension DTBKitWrapper where Base == Double {
    
    
    
}
