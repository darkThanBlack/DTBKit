//
//  UIEdgeInsets+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/29
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension UIEdgeInsets: Structable {}

extension StaticWrapper where T == UIEdgeInsets {
    
    /// top | left | bottom | right
    @inline(__always)
    public func create(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> T {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    @inline(__always)
    public func create(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> T {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    @inline(__always)
    public func create(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> T {
        return UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    @inline(__always)
    public func create(all value: CGFloat) -> T {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
}
