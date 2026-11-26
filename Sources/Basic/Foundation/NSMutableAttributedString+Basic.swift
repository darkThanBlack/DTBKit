//
//  NSAttributedString+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/23
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
extension Wrapper where Base: NSMutableAttributedString {
    
    ///
    @inline(__always)
    public func string() -> Wrapper<String> {
        return me.string.dtb
    }
    
    ///
    @inline(__always)
    public func mString() -> Wrapper<NSMutableString> {
        return me.mutableString.dtb
    }
    
    /// Append.
    ///
    /// Example:
    /// ```
    /// let attr = "".dtb.attr.append(
    ///     "text",
    ///     DTB.AttributedStyle(
    ///         font: .systemFont(ofSize: 13.0),
    ///         foregroundColor: .black
    ///     )
    /// ).value
    /// ```
    @discardableResult
    public func append(_ string: String?, _ style: DTB.AttributedStyle?) -> Self {
        if let str = string, str.isEmpty == false {
            me.append(NSAttributedString(string: str, attributes: style?.attr))
        }
        return self
    }
    
    /// Same as ``setAttributes:``, search subString with nsRange.
    ///
    /// 没搜索到则不做处理。
    @discardableResult
    public func setSub(_ subString: String, style: DTB.AttributedStyle? = nil) -> Self {
        let range = string().ns().range(of: subString).value
        guard string().has(nsRange: range) else {
            return self
        }
        me.setAttributes(style?.attr, range: range)
        return self
    }
    
    /// Same as ``addAttributes``, search subString with nsRange.
    ///
    /// 没搜索到则不做处理。
    @discardableResult
    public func addSub(_ subString: String, style: DTB.AttributedStyle) -> Self {
        let range = string().ns().range(of: subString).value
        guard string().has(nsRange: range) else {
            return self
        }
        me.addAttributes(style.attr, range: range)
        return self
    }
}
