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
    public var str: DTBKitWrapper<String> {
        return me.string.dtb
    }
    
    ///
    public var mStr: DTBKitWrapper<NSMutableString> {
        return me.mutableString.dtb
    }
    
    /// Multi append.
    ///
    /// 一次性添加多个。
    ///
    /// For example:
    /// ```
    ///   NSMutableAttributedString().dtb.append(items:[
    ///       ("", [:].dtb.set.font(.systemFont(ofSize: 13.0)).value),
    ///       ("", [:].dtb.set.foregroundColor(.white).value)
    ///   ])
    /// ```
    @discardableResult
    public func append(items: [(_: String, _: [NSAttributedString.Key: Any]?)]) -> Self {
        items.forEach({
            me.append(NSAttributedString(string: $0.0, attributes: $0.1))
        })
        return self
    }
    
    /// Same as ``setAttributes:``, search subString with nsRange.
    ///
    /// 没搜索到则不做处理。
    @discardableResult
    public func reset(_ subString: String, attrs: [NSAttributedString.Key : Any]? = nil) -> Self {
        let range = str.ns.range(of: subString).value
        guard str.has(nsRange: range) else {
            return self
        }
        me.setAttributes(attrs, range: range)
        return self
    }
    
    /// Same as ``addAttributes``, search subString with nsRange.
    ///
    /// 没搜索到则不做处理。
    @discardableResult
    public func add(_ subString: String, attrs: [NSAttributedString.Key : Any]) -> Self {
        let range = str.ns.range(of: subString).value
        guard str.has(nsRange: range) else {
            return self
        }
        me.addAttributes(attrs, range: range)
        return self
    }
}
