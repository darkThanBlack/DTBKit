//
//  AttributedStringKey+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/21
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Create attributes dictionary chainable.
///
/// 通过链式语法创建字典以支持强类型检查。
///
/// Sample:
/// ```
///     NSAttributedString(
///         string: "str",
///         attributes: .dtb.create
///             .font(.systemFont(ofSize: 13.0))
///             .foregroundColor(.white)
///             .value
///     )
/// ```
extension MutableWrapper where Base == Dictionary<NSAttributedString.Key, Any> {
    
    @inline(__always)
    @discardableResult
    public func font(_ value: UIFont) -> Self {
        me[.font] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func paragraphStyle(_ value: NSParagraphStyle) -> Self {
        me[.paragraphStyle] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func foregroundColor(_ value: UIColor?) -> Self {
        me[.foregroundColor] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func backgroundColor(_ value: UIColor?) -> Self {
        me[.backgroundColor] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func ligature(_ value: Int) -> Self {
        me[.ligature] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func kern(_ value: CGFloat) -> Self {
        me[.kern] = value
        return self
    }
    
    @available(iOS 14.0, *)
    @inline(__always)
    @discardableResult
    public func tracking(_ value: CGFloat) -> Self {
        me[.tracking] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func strikethroughStyle(_ value: Int) -> Self {
        me[.strikethroughStyle] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func underlineStyle(_ value: Int) -> Self {
        me[.underlineStyle] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func strokeColor(_ value: UIColor) -> Self {
        me[.strokeColor] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func strokeWidth(_ value: CGFloat) -> Self {
        me[.strokeWidth] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func shadow(_ value: NSShadow?) -> Self {
        me[.shadow] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func textEffect(_ value: String?) -> Self {
        me[.textEffect] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func attachment(_ value: NSTextAttachment?) -> Self {
        me[.attachment] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func link(url value: URL?) -> Self {
        me[.link] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func link(str value: String?) -> Self {
        me[.link] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func baselineOffset(_ value: CGFloat) -> Self {
        me[.baselineOffset] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func underlineColor(_ value: UIColor?) -> Self {
        me[.underlineColor] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func strikethroughColor(_ value: UIColor?) -> Self {
        me[.strikethroughColor] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func obliqueness(_ value: CGFloat) -> Self {
        me[.obliqueness] = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func expansion(direction: NSWritingDirection, formatType: NSWritingDirectionFormatType) -> Self {
        me[.expansion] = direction.rawValue | formatType.rawValue
        return self
    }
}
