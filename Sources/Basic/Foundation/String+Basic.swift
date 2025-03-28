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
           nsRange.location < ns().value.length,
           nsRange.location + nsRange.length < ns().value.length {
            return true
        }
        return false
    }
    
    /// 从头开始截取字符串，基于UTF-16码元长度，确保返回完整的Unicode字符
    ///
    /// 该方法截取字符串时，确保不会截断Unicode字符，最多返回指定UTF-16码元长度的子串
    ///
    /// - 示例:
    ///   - 常规情况："12345".xmPrefix(4) => "1234"
    ///   - 特殊情况："123👧45".xmPrefix(4) => "123" 而不是"123�"
    ///
    /// - Parameter length: 要截取的最大UTF-16码元长度
    /// - Returns: 截取后的子字符串
    public func prefix(_ length: Int) -> Self? {
        // 边界情况处理
        guard length > 0 else { return nil }
        
        // 检查整个字符串的UTF-16长度是否小于或等于要求的长度
        let nsString = me as NSString
        if nsString.length <= length {
            return self
        }
        
        // 利用UTF-16视图直接找到合适的截断位置
        var characterIndex = me.startIndex
        var utf16Count = 0
        
        // 遍历字符串中的每个字符
        for char in me {
            let charUTF16Count = String(char).utf16.count
            
            // 检查添加当前字符是否会超出长度限制
            if utf16Count + charUTF16Count > length {
                break
            }
            
            utf16Count += charUTF16Count
            characterIndex = me.index(after: characterIndex)
        }
        
        // 返回截取到合适位置的子串
        return String(me[..<characterIndex]).dtb
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

/// Format
extension Wrapper where Base == String {
    
    /// Convert to ``Date``.
    public func toDate(_ formatter: @autoclosure (() -> DateFormatter)) -> Wrapper<Date>? {
        return formatter().date(from: me)?.dtb
    }
    
    /// Format to ``Date``.
    public func formatDate(_ str: String = "yyyy-MM-dd HH:mm") -> Wrapper<Date>? {
        return DTB.Configuration.shared.dateFormatter.dtb.dateFormat(str).value.date(from: me)?.dtb
    }
}

/// Data
public extension Wrapper where Base == String {
    
}

/// Json
public extension Wrapper where Base == String {
    
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
