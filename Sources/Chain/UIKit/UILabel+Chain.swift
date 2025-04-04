//
//  UILabel+Chain.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/20
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
extension Wrapper where Base: UILabel & Chainable {
    
    @inline(__always)
    @discardableResult
    public func text(_ value: String?) -> Self {
        me.text = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func font(_ value: UIFont) -> Self {
        me.font = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func textColor(_ value: UIColor) -> Self {
        me.textColor = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func shadowColor(_ value: UIColor) -> Self {
        me.shadowColor = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func shadowOffset(_ value: CGSize) -> Self {
        me.shadowOffset = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func textAlignment(_ value: NSTextAlignment) -> Self {
        me.textAlignment = value
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
    public func attributedText(_ value: NSAttributedString?) -> Self {
        me.attributedText = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func numberOfLines(_ value: Int) -> Self {
        me.numberOfLines = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        me.adjustsFontSizeToFitWidth = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func baselineAdjustment(_ value: UIBaselineAdjustment) -> Self {
        me.baselineAdjustment = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func minimumScaleFactor(_ value: CGFloat) -> Self {
        me.minimumScaleFactor = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func allowsDefaultTighteningForTruncation(_ value: Bool) -> Self {
        me.allowsDefaultTighteningForTruncation = value
        return self
    }
    
    @available(iOS 14.0, *)
    @inline(__always)
    @discardableResult
    public func lineBreakStrategy(_ value: NSParagraphStyle.LineBreakStrategy) -> Self {
        me.lineBreakStrategy = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func preferredMaxLayoutWidth(_ value: CGFloat) -> Self {
        me.preferredMaxLayoutWidth = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func showsExpansionTextWhenTruncated(_ value: Bool) -> Self {
        me.showsExpansionTextWhenTruncated = value
        return self
    }
}
