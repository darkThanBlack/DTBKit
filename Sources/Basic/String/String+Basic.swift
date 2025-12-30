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
    
    /// Convert to ``NSMutableAttributedString``.
    @inline(__always)
    public func attr() -> Wrapper<NSMutableAttributedString> {
        return NSMutableAttributedString(string: me).dtb
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
    
    /// 是否为空
    @inline(__always)
    public func isEmpty() -> Bool {
        return me.isEmpty
    }
    
    /// 是否空白（空或仅包含空白字符）
    @inline(__always)
    public func isBlank() -> Bool {
        return me.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty
    }
    
    /// 去首尾空白  ``trimmingCharacters(in:.whitespacesAndNewlines)``
    @inline(__always)
    public func noBlank() -> Self {
        return me.trimmingCharacters(in:.whitespacesAndNewlines).dtb
    }
    
    /// 检查字符串中的所有字符是否都在指定的字符集中
    ///
    /// - Parameter chars: 字符集
    /// - Returns: 如果所有字符都在字符集中返回 true，否则返回 false
    @inline(__always)
    public func allSatisfy(chars: CharacterSet) -> Bool {
        guard !me.isEmpty else { return false }
        return me.unicodeScalars.allSatisfy { chars.contains($0) }
    }
    
    /// 字符串是否是纯数字，不包含正负号和小数点
    @inline(__always)
    public func isPureInt() -> Bool {
        return allSatisfy(chars: CharacterSet(charactersIn: "0123456789"))
    }
    
    /// Check if the range is out of bounds.
    ///
    /// 越界检查。
    public func has(nsRange: NSRange) -> Bool {
        guard nsRange.dtb.isEmpty() == false else {
            return false
        }
        return NSMaxRange(nsRange) <= ns().value.length
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
