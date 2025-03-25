//
//  String+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/8
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Type converts
extension DTBKitWrapper where Base == String {
    
    /// Convert to ``NSString``.
    @inline(__always)
    public func ns() -> DTBKitWrapper<NSString> {
        return NSString(string: me).dtb
    }
    
    /// Convert to ``NSDecimalNumber``. Return ``nil`` when isNaN.
    ///
    /// ```
    /// "1.0".dtb.nsDecimal
    ///     .plus("1.0")
    ///     .div(3, scale: 3, rounding: .down)
    ///     .double.value === 0.666
    /// ```
    @inline(__always)
    public func nsDecimal() -> DTBKitWrapper<NSDecimalNumber>? {
        let result = NSDecimalNumber(string: me)
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
    /// Convert to ``NSMutableAttributedString``.
    @inline(__always)
    public func attr() -> DTBKitWrapper<NSMutableAttributedString> {
        return NSMutableAttributedString(string: me).dtb
    }
    
    /// Convert to ``Int64``.
    @inline(__always)
    public func int64() -> DTBKitWrapper<Int64>? {
        return Int64(me)?.dtb
    }
    
    /// Convert to ``Double``.
    @inline(__always)
    public func double() -> DTBKitWrapper<Double>? {
        return Double(me)?.dtb
    }
}

/// Basic
extension DTBKitWrapper where Base == String {
    
    /// Use ``utf16.count`` to make same as ``NSString.length``.
    ///
    /// 保持取值逻辑与常规理解一致；
    /// 需要背景知识: String 和 NSString 的不同之处。
    @inline(__always)
    public func count() -> Int {
        return me.utf16.count
    }
    
    /// Check if the range is out of bounds.
    ///
    /// 越界检查。
    public func has(nsRange: NSRange) -> Bool {
        if nsRange.dtb.isEmpty() == false,
           nsRange.location < ns().value.length,
           nsRange.location + nsRange.length < ns().value.length {
            return true
        }
        return false
    }
}

/// Regular
extension DTBKitWrapper where Base == String {
    
    /// Use ``NSPredicate`` to fire regular.
    @inline(__always)
    public func isMatches(_ exp: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", exp).evaluate(with: me)
    }
    
    /// Use ``NSPredicate`` to fire boxed regular.
    ///
    /// ```
    /// "18212345678".dtb.isRegular(.phoneNumber)
    /// ```
    @inline(__always)
    public func isRegular(_ value: DTB.Regulars) -> Bool {
        return isMatches(value.exp)
    }
}

/// Json
public extension DTBKitWrapper where Base == String {
    
    /// Encoding to ``Data``
    @inline(__always)
    func data(_ encoding: String.Encoding = .utf8, _ lossy: Bool = true) -> Data? {
        return me.data(using: encoding, allowLossyConversion: lossy)
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func json<T>() -> T? {
        guard let data = me.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)) as? T
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func jsonDict() -> [String: Any]? {
        return json()
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func jsonArray() -> [Any]? {
        return json()
    }
}
