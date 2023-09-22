//
//  UIView+Chain.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/9/22
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTBKitWeakWrapper where Base: UIView {
    /// Auto set converted size
    ///
    /// - Parameters:
    ///   - value: same as ``size``
    ///   - setter: you can convert result size to another
//    @discardableResult
//    public func sizeThatFits(_ value: CGSize, setter: ((_ size: CGSize)->(CGSize))?) -> Self {
//        if let nSize = setter?(me.sizeThatFits(value)) {
//            me.frame = CGRect(x: me.frame.origin.x, y: me.frame.origin.y, width: nSize.width, height: nSize.height)
//            me.bounds = CGRect(x: me.bounds.origin.x, y: me.bounds.origin.y, width: nSize.width, height: nSize.height)
//        }
//        return self
//    }
    
    //    public func isDescendant(of view: UIView) -> Bool
    //
    //    public func viewWithTag(_ tag: Int) -> UIView?

}

//MARK: - UIView

extension DTBKitWeakWrapper where Base: UIView {
    
    @discardableResult
    public func isUserInteractionEnabled(_ value: Bool) -> Self {
        me?.isUserInteractionEnabled = value
        return self
    }
    
    @discardableResult
    public func tag(_ value: Int) -> Self {
        me?.tag = value
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ value: UIColor?) -> Self {
        me?.backgroundColor = value
        return self
    }
    
}

//MARK: - Geometry

/// Same as ``@interface UIView(UIViewGeometry)``
extension DTBKitWeakWrapper where Base: UIView {
    
    @discardableResult
    public func frame(_ value: CGRect) -> Self {
        me?.frame = value
        return self
    }
    
    @discardableResult
    public func bounds(_ value: CGRect) -> Self {
        me?.bounds = value
        return self
    }
    
    @discardableResult
    public func center(_ value: CGPoint) -> Self {
        me?.center = value
        return self
    }
    
    @discardableResult
    public func transform(_ value: CGAffineTransform) -> Self {
        me?.transform = value
        return self
    }
    
    @discardableResult
    public func autoresizesSubviews(_ value: Bool) -> Self {
        me?.autoresizesSubviews = value
        return self
    }
    
    @discardableResult
    public func autoresizingMask(_ value: UIView.AutoresizingMask) -> Self {
        me?.autoresizingMask = value
        return self
    }
    
    @discardableResult
    public func sizeToFit() -> Self {
        me?.sizeToFit()
        return self
    }
}

//MARK: - Hierarchy

/// Same as ``@interface UIView(UIViewHierarchy)``
extension DTBKitWeakWrapper where Base: UIView {
    
    @discardableResult
    public func removeFromSuperview() -> Self {
        me?.removeFromSuperview()
        return self
    }
    
    @discardableResult
    public func insertSubview(_ view: UIView, at index: Int) -> Self {
        me?.insertSubview(view, at: index)
        return self
    }
    
    @discardableResult
    public func exchangeSubview(at index1: Int, withSubviewAt index2: Int) -> Self {
        me?.exchangeSubview(at: index1, withSubviewAt: index2)
        return self
    }
    
    @discardableResult
    public func addSubview(_ view: UIView) -> Self {
        me?.addSubview(view)
        return self
    }
    
    @discardableResult
    public func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) -> Self {
        me?.insertSubview(view, belowSubview: siblingSubview)
        return self
    }
    
    @discardableResult
    public func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) -> Self {
        me?.insertSubview(view, aboveSubview: siblingSubview)
        return self
    }
    
    @discardableResult
    public func bringSubviewToFront(_ view: UIView) -> Self {
        me?.bringSubviewToFront(view)
        return self
    }
    
    @discardableResult
    public func sendSubviewToBack(_ view: UIView) -> Self {
        me?.sendSubviewToBack(view)
        return self
    }
    
    @discardableResult
    public func setNeedsLayout() -> Self {
        me?.setNeedsLayout()
        return self
    }
    
    @discardableResult
    public func layoutIfNeeded() -> Self {
        me?.layoutIfNeeded()
        return self
    }
}

//MARK: - Rendering

/// Same as ``@interface UIView(UIViewRendering)``
extension DTBKitWeakWrapper where Base: UIView {
    
    
    
}

//MARK: - Animation

