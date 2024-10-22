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

/// See more details in ``dtbkit_adapter.md``
public protocol DTBKitAdapterForString {
    
    associatedtype StringParam = String
    
    /// Text generate | 文本生成收口
    ///
    /// 便于处理 国际化 等需求
    func create(_ key: StringParam) -> String
}

extension DTBKitAdapterForString where StringParam == String {
    
    public func create(_ key: StringParam) -> String {
        return key
    }
}

/// Type converts
extension DTBKitWrapper where Base == String {
    
    /// Convert to ``NSString``.
    public var ns: DTBKitWrapper<NSString> {
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
    public var nsDecimal: DTBKitWrapper<NSDecimalNumber>? {
        let result = NSDecimalNumber(string: me)
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
    /// Convert to ``NSMutableAttributedString``.
    public var attr: DTBKitWrapper<NSMutableAttributedString> {
        return NSMutableAttributedString(string: me).dtb
    }
    
    /// Convert to ``Int64``.
    public var int64: DTBKitWrapper<Int64>? {
        return Int64(me)?.dtb
    }
    
    /// Convert to ``Double``.
    public var double: DTBKitWrapper<Double>? {
        return Double(me)?.dtb
    }
}

/// Basic
extension DTBKitWrapper where Base == String {
    
    /// Use ``utf16.count`` to make same as ``NSString.length``.
    ///
    /// 保持取值逻辑与常规理解一致；
    /// 需要背景知识: String 和 NSString 的不同之处。
    public var count: Int {
        return me.utf16.count
    }
    
    /// Check if the range is out of bounds.
    ///
    /// 越界检查。
    public func has(nsRange: NSRange) -> Bool {
        if nsRange.dtb.isEmpty == false,
           nsRange.location < ns.value.length,
           nsRange.location + nsRange.length < ns.value.length {
            return true
        }
        return false
    }
}

/// Regular
extension DTBKitWrapper where Base == String {
    
    /// Use ``NSPredicate`` to fire regular.
    public func isMatches(_ exp: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", exp).evaluate(with: me)
    }
    
    /// Use ``NSPredicate`` to fire boxed regular.
    ///
    /// ```
    /// "18212345678".dtb.isRegular(.phoneNumber)
    /// ```
    public func isRegular(_ value: DTB.Regulars) -> Bool {
        return isMatches(value.exp)
    }
}

/// Json
public extension DTBKitWrapper where Base == String {
    
    /// Encoding to ``Data``
    func data(_ encoding: String.Encoding = .utf8, _ lossy: Bool = true) -> Data? {
        return me.data(using: encoding, allowLossyConversion: lossy)
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    func json<T>() -> T? {
        guard let data = me.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)) as? T
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    func jsonDict() -> [String: Any]? {
        return json()
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    func jsonArray() -> [Any]? {
        return json()
    }
}
