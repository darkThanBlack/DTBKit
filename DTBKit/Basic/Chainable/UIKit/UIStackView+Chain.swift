//
//  UIStackView+Chain.swift
//  XMKit
//
//  Created by moonShadow on 2024/1/4
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension XMKitWrapper where Base: UIStackView {
    
    @discardableResult
    public func axis(_ value: NSLayoutConstraint.Axis) -> Self {
        me.axis = value
        return self
    }
    
    @discardableResult
    public func distribution(_ value: UIStackView.Distribution) -> Self {
        me.distribution = value
        return self
    }
    
    @discardableResult
    public func alignment(_ value: UIStackView.Alignment) -> Self {
        me.alignment = value
        return self
    }
    
    @discardableResult
    public func spacing(_ value: CGFloat) -> Self {
        me.spacing = value
        return self
    }
    
    @discardableResult
    public func addArrangedSubview(_ view: UIView) -> Self {
        me.addArrangedSubview(view)
        return self
    }
    
    @discardableResult
    public func insertArrangedSubview(_ view: UIView, at stackIndex: Int) -> Self {
        me.insertArrangedSubview(view, at: stackIndex)
        return self
    }
}
