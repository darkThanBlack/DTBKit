//
//  UIStackView+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/4
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: UIStackView {
    
    @inline(__always)
    @discardableResult
    public func axis(_ value: NSLayoutConstraint.Axis) -> Self {
        me.axis = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func distribution(_ value: UIStackView.Distribution) -> Self {
        me.distribution = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func alignment(_ value: UIStackView.Alignment) -> Self {
        me.alignment = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func spacing(_ value: CGFloat) -> Self {
        me.spacing = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func addArrangedSubview(_ view: UIView) -> Self {
        me.addArrangedSubview(view)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func insertArrangedSubview(_ view: UIView, at stackIndex: Int) -> Self {
        me.insertArrangedSubview(view, at: stackIndex)
        return self
    }
}
