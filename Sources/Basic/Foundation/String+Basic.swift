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
extension Wrapper where Base == String {
    
    /// Convert to ``NSString``.
    @inline(__always)
    public func ns() -> Wrapper<NSString> {
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
    public func nsDecimal() -> Wrapper<NSDecimalNumber>? {
        let result = NSDecimalNumber(string: me)
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
    /// Convert to ``NSMutableAttributedString``.
    @inline(__always)
    public func attr() -> Wrapper<NSMutableAttributedString> {
        return NSMutableAttributedString(string: me).dtb
    }
    
    /// Convert to ``Int64``.
    @inline(__always)
    public func int64() -> Wrapper<Int64>? {
        return Int64(me)?.dtb
    }
    
    /// Convert to ``Double``.
    @inline(__always)
    public func double() -> Wrapper<Double>? {
        return Double(me)?.dtb
    }
    
    /// Convert to ``CGFloat``.
    @inline(__always)
    public func cgFloat() -> Wrapper<CGFloat>? {
        guard let value = Double(me) else {
            return nil
        }
        return CGFloat(value).dtb
    }
}

/// Basic
extension Wrapper where Base == String {
    
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
           NSMaxRange(nsRange) <= ns().value.length {
            return true
        }
        return false
    }
}

/// Regular
extension Wrapper where Base == String {
    
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

/// Data
public extension Wrapper where Base == String {
    
    /// Encoding to ``Data``
    @inline(__always)
    func data(_ encoding: String.Encoding = .utf8, _ lossy: Bool = true) -> Data? {
        return me.data(using: encoding, allowLossyConversion: lossy)
    }
}
