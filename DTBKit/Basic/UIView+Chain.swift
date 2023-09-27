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

//
// Type 1:
// 1> iOS 11.0 +
// 2> func without results
// 3> sort as UIKit
//
// Type 2:
// 1> iOS *
// 2> func return another types
//
// Type 3:
// 1> static / class func
//
// Type 4:
// 1> custom helper
//

///
extension DTBKitWrapper where Base: UIView {
    
    @discardableResult
    public func isUserInteractionEnabled(_ value: Bool) -> Self {
        me.isUserInteractionEnabled = value
        return self
    }
    
    @discardableResult
    public func tag(_ value: Int) -> Self {
        me.tag = value
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ value: UIColor?) -> Self {
        me.backgroundColor = value
        return self
    }
}

/// Same as ``@interface UIView(UIViewGeometry)``
extension DTBKitWrapper where Base: UIView {
    
    @discardableResult
    public func frame(_ value: CGRect) -> Self {
        me.frame = value
        return self
    }
    
    @discardableResult
    public func bounds(_ value: CGRect) -> Self {
        me.bounds = value
        return self
    }
    
    @discardableResult
    public func center(_ value: CGPoint) -> Self {
        me.center = value
        return self
    }
    
    @discardableResult
    public func transform(_ value: CGAffineTransform) -> Self {
        me.transform = value
        return self
    }
    
    @discardableResult
    public func isMultipleTouchEnabled(_ value: Bool) -> Self {
        me.isMultipleTouchEnabled = value
        return self
    }
    
    @discardableResult
    public func isExclusiveTouch(_ value: Bool) -> Self {
        me.isExclusiveTouch = value
        return self
    }
    
    @discardableResult
    public func autoresizesSubviews(_ value: Bool) -> Self {
        me.autoresizesSubviews = value
        return self
    }
    
    @discardableResult
    public func autoresizingMask(_ value: UIView.AutoresizingMask) -> Self {
        me.autoresizingMask = value
        return self
    }
    
    @discardableResult
    public func sizeToFit() -> Self {
        me.sizeToFit()
        return self
    }
}

/// Same as ``@interface UIView(UIViewHierarchy)``
extension DTBKitWrapper where Base: UIView {
    
    @discardableResult
    public func removeFromSuperview() -> Self {
        me.removeFromSuperview()
        return self
    }
    
    @discardableResult
    public func insertSubview(_ view: UIView, at index: Int) -> Self {
        me.insertSubview(view, at: index)
        return self
    }
    
    @discardableResult
    public func exchangeSubview(at index1: Int, withSubviewAt index2: Int) -> Self {
        me.exchangeSubview(at: index1, withSubviewAt: index2)
        return self
    }
    
    @discardableResult
    public func addSubview(_ view: UIView) -> Self {
        me.addSubview(view)
        return self
    }
    
    @discardableResult
    public func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) -> Self {
        me.insertSubview(view, belowSubview: siblingSubview)
        return self
    }
    
    @discardableResult
    public func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) -> Self {
        me.insertSubview(view, aboveSubview: siblingSubview)
        return self
    }
    
    @discardableResult
    public func bringSubviewToFront(_ view: UIView) -> Self {
        me.bringSubviewToFront(view)
        return self
    }
    
    @discardableResult
    public func sendSubviewToBack(_ view: UIView) -> Self {
        me.sendSubviewToBack(view)
        return self
    }
    
    @discardableResult
    public func viewWithTag(_ tag: Int) -> DTBKitWrapper<UIView>? {
        return me.viewWithTag(tag)?.dtb
    }
    
    @discardableResult
    public func setNeedsLayout() -> Self {
        me.setNeedsLayout()
        return self
    }
    
    @discardableResult
    public func layoutIfNeeded() -> Self {
        me.layoutIfNeeded()
        return self
    }
    
    @discardableResult
    public func layoutMargins(_ value: UIEdgeInsets) -> Self {
        me.layoutMargins = value
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func directionalLayoutMargins(_ value: NSDirectionalEdgeInsets) -> Self {
        me.directionalLayoutMargins = value
        return self
    }
    
    @discardableResult
    public func preservesSuperviewLayoutMargins(_ value: Bool) -> Self {
        me.preservesSuperviewLayoutMargins = value
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func insetsLayoutMarginsFromSafeArea(_ value: Bool) -> Self {
        me.insetsLayoutMarginsFromSafeArea = value
        return self
    }
}

/// Same as ``@interface UIView(UIViewRendering)``
extension DTBKitWrapper where Base: UIView {
    
    @discardableResult
    public func setNeedsDisplay() -> Self {
        me.setNeedsDisplay()
        return self
    }
    
    @discardableResult
    public func setNeedsDisplay(_ rect: CGRect) -> Self {
        me.setNeedsDisplay(rect)
        return self
    }
    
    @discardableResult
    public func clipsToBounds(_ value: Bool) -> Self {
        me.clipsToBounds = value
        return self
    }
    
    @discardableResult
    public func alpha(_ value: CGFloat) -> Self {
        me.alpha = value
        return self
    }
    
    @discardableResult
    public func isOpaque(_ value: Bool) -> Self {
        me.isOpaque = value
        return self
    }
    
    @discardableResult
    public func clearsContextBeforeDrawing(_ value: Bool) -> Self {
        me.clearsContextBeforeDrawing = value
        return self
    }
    
    @discardableResult
    public func isHidden(_ value: Bool) -> Self {
        me.isHidden = value
        return self
    }
    
    @discardableResult
    public func contentMode(_ value: UIView.ContentMode) -> Self {
        me.contentMode = value
        return self
    }
    
    @discardableResult
    public func mask(_ value: UIView?) -> Self {
        me.mask = value
        return self
    }
    
    @discardableResult
    public func tintColor(_ value: UIColor) -> Self {
        me.tintColor = value
        return self
    }
    
    @discardableResult
    public func tintAdjustmentMode(_ value: UIView.TintAdjustmentMode) -> Self {
        me.tintAdjustmentMode = value
        return self
    }
}

// UIViewAnimation

// UIViewAnimationWithBlocks

// UIViewKeyframeAnimations

/// Same as ``@interface UIView(UIViewGestureRecognizers)``
extension DTBKitWrapper where Base: UIView {
    
    @discardableResult
    public func gestureRecognizers(_ value: [UIGestureRecognizer]?) -> Self {
        me.gestureRecognizers = value
        return self
    }
    
    @discardableResult
    public func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        me.addGestureRecognizer(gestureRecognizer)
        return self
    }
    
    @discardableResult
    public func removeGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        me.removeGestureRecognizer(gestureRecognizer)
        return self
    }
}

/// Same as ``@interface UIView(UIViewMotionEffects)``
extension DTBKitWrapper where Base: UIView {
    
    @discardableResult
    public func addMotionEffect(_ effect: UIMotionEffect) -> Self {
        me.addMotionEffect(effect)
        return self
    }
    
    @discardableResult
    public func removeMotionEffect(_ effect: UIMotionEffect) -> Self {
        me.removeMotionEffect(effect)
        return self
    }
}

// UIConstraintBasedLayoutInstallingConstraints

/// Same as ``@interface UIView(UIConstraintBasedLayoutCoreMethods)``
extension DTBKitWrapper where Base: UIView {
    
    @discardableResult
    public func setNeedsUpdateConstraints() -> Self {
        me.setNeedsUpdateConstraints()
        return self
    }
}

/// Same as ``@interface UIView(UIConstraintBasedCompatibility)``
extension DTBKitWrapper where Base: UIView {
    
    @discardableResult
    public func translatesAutoresizingMaskIntoConstraints(_ value: Bool) -> Self {
        me.translatesAutoresizingMaskIntoConstraints = value
        return self
    }
}

/// Same as ``@interface UIView(UIConstraintBasedLayoutLayering)``
extension DTBKitWrapper where Base: UIView {
    
    @discardableResult
    public func invalidateIntrinsicContentSize() -> Self {
        me.invalidateIntrinsicContentSize()
        return self
    }
    
    @discardableResult
    public func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        me.setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    @discardableResult
    public func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        me.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
}

/// Same as ``@interface UIView(UILayoutGuideSupport)``
extension DTBKitWrapper where Base: UIView {
    
    @discardableResult
    public func addLayoutGuide(_ layoutGuide: UILayoutGuide) -> Self {
        me.addLayoutGuide(layoutGuide)
        return self
    }
    
    @discardableResult
    public func removeLayoutGuide(_ layoutGuide: UILayoutGuide) -> Self {
        me.removeLayoutGuide(layoutGuide)
        me.snapshotView(afterScreenUpdates: true)
        return self
    }
}

// UIViewLayoutConstraintCreation

// UIConstraintBasedLayoutDebugging

// UIStateRestoration

// UISnapshotting

// DeprecatedAnimations

// UserInterfaceStyle

// UIContentSizeCategoryLimit

