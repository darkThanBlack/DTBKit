//
//  NSMutableParagraphStyle+Chain.swift
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
extension Wrapper where Base: NSMutableParagraphStyle & Chainable {
    
    @inline(__always)
    @discardableResult
    public func lineSpacing(_ value: CGFloat) -> Self {
        me.lineSpacing = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func paragraphSpacing(_ value: CGFloat) -> Self {
        me.paragraphSpacing = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func alignment(_ value: NSTextAlignment) -> Self {
        me.alignment = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func firstLineHeadIndent(_ value: CGFloat) -> Self {
        me.firstLineHeadIndent = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func headIndent(_ value: CGFloat) -> Self {
        me.headIndent = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func tailIndent(_ value: CGFloat) -> Self {
        me.tailIndent = value
        return self
    }

    @inline(__always)
    @discardableResult
    public func lineBreakMode(_ value: NSLineBreakMode) -> Self {
        me.lineBreakMode = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func minimumLineHeight(_ value: CGFloat) -> Self {
        me.minimumLineHeight = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func maximumLineHeight(_ value: CGFloat) -> Self {
        me.maximumLineHeight = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func baseWritingDirection(_ value: NSWritingDirection) -> Self {
        me.baseWritingDirection = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func lineHeightMultiple(_ value: CGFloat) -> Self {
        me.lineHeightMultiple = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func paragraphSpacingBefore(_ value: CGFloat) -> Self {
        me.paragraphSpacingBefore = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func hyphenationFactor(_ value: Float) -> Self {
        me.hyphenationFactor = value
        return self
    }
    
    @available(iOS 15.0, *)
    @inline(__always)
    @discardableResult
    public func usesDefaultHyphenation(_ value: Bool) -> Self {
        me.usesDefaultHyphenation = value
        return self
    }
    
    
    @inline(__always)
    @discardableResult
    public func tabStops(_ value: [NSTextTab]) -> Self {
        me.tabStops = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func defaultTabInterval(_ value: CGFloat) -> Self {
        me.defaultTabInterval = value
        return self
    }
    
    @available(iOS 9.0, *)
    @inline(__always)
    @discardableResult
    public func allowsDefaultTighteningForTruncation(_ value: Bool) -> Self {
        me.allowsDefaultTighteningForTruncation = value
        return self
    }
    
    @available(iOS 9.0, *)
    @inline(__always)
    @discardableResult
    public func lineBreakStrategy(_ value: NSParagraphStyle.LineBreakStrategy) -> Self {
        me.lineBreakStrategy = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func textLists(_ value: [NSTextList]) -> Self {
        me.textLists = value
        return self
    }
    
    @available(iOS 9.0, *)
    @inline(__always)
    @discardableResult
    public func addTabStop(_ value: NSTextTab) -> Self {
        me.addTabStop(value)
        return self
    }
    
    @available(iOS 9.0, *)
    @inline(__always)
    @discardableResult
    public func removeTabStop(_ value: NSTextTab) -> Self {
        me.removeTabStop(value)
        return self
    }
    
    @available(iOS 9.0, *)
    @inline(__always)
    @discardableResult
    public func setParagraphStyle(_ value: NSParagraphStyle) -> Self {
        me.setParagraphStyle(value)
        return self
    }
}
