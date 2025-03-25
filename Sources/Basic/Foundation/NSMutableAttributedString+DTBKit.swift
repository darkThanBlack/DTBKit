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
extension DTBKitWrapper where Base: NSMutableAttributedString {
    
    ///
    public func string() -> DTBKitWrapper<String> {
        return me.string.dtb
    }
    
    ///
    public func mString() -> DTBKitWrapper<NSMutableString> {
        return me.mutableString.dtb
    }
    
    /// Append.
    ///
    /// Example:
    /// ```
    /// let attr = "".dtb.attr.append(
    ///     "text",
    ///     .dtb.create
    ///         .foregroundColor(.black)
    ///         .font(.systemFont(ofSize: 13.0))
    ///         .value
    /// ).value
    /// ```
    @discardableResult
    public func append(_ string: String?, _ attributes: [NSAttributedString.Key: Any]?) -> Self {
        if let str = string, str.isEmpty == false {
            me.append(NSAttributedString(string: str, attributes: attributes))
        }
        return self
    }
    
    /// Same as ``setAttributes:``, search subString with nsRange.
    ///
    /// 没搜索到则不做处理。
    @discardableResult
    public func setSub(_ subString: String, attrs: [NSAttributedString.Key : Any]? = nil) -> Self {
        let range = string().ns().range(of: subString).value
        guard string().has(nsRange: range) else {
            return self
        }
        me.setAttributes(attrs, range: range)
        return self
    }
    
    /// Same as ``addAttributes``, search subString with nsRange.
    ///
    /// 没搜索到则不做处理。
    @discardableResult
    public func addSub(_ subString: String, attrs: [NSAttributedString.Key : Any]) -> Self {
        let range = string().ns().range(of: subString).value
        guard string().has(nsRange: range) else {
            return self
        }
        me.addAttributes(attrs, range: range)
        return self
    }
}
