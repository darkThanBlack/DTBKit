//
//  NSMutableAttributedString+Chain.swift
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
extension Wrapper where Base: NSMutableAttributedString & Chainable {
    
    @inline(__always)
    @discardableResult
    public func replaceCharacters(in range: NSRange, with str: String) -> Self {
        me.replaceCharacters(in: range, with: str)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) -> Self {
        me.setAttributes(attrs, range: range)
        return self
    }
}

/// NSExtendedMutableAttributedString
extension Wrapper where Base: NSMutableAttributedString & Chainable {
    
    @inline(__always)
    @discardableResult
    public func addAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange) -> Self {
        me.addAttribute(name, value: value, range: range)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func addAttributes(_ attrs: [NSAttributedString.Key : Any] = [:], range: NSRange) -> Self {
        me.addAttributes(attrs, range: range)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func removeAttribute(_ name: NSAttributedString.Key, range: NSRange) -> Self {
        me.removeAttribute(name, range: range)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func replaceCharacters(in range: NSRange, with attrString: NSAttributedString) -> Self {
        me.replaceCharacters(in: range, with: attrString)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func insert(_ attrString: NSAttributedString, at loc: Int) -> Self {
        me.insert(attrString, at: loc)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func append(_ attrString: NSAttributedString) -> Self {
        me.append(attrString)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func deleteCharacters(in range: NSRange) -> Self {
        me.deleteCharacters(in: range)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setAttributedString(_ attrString: NSAttributedString) -> Self {
        me.setAttributedString(attrString)
        me.beginEditing()
        return self
    }
}
