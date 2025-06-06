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

///
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func isUserInteractionEnabled(_ value: Bool) -> Self {
        me.isUserInteractionEnabled = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func tag(_ value: Int) -> Self {
        me.tag = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func backgroundColor(_ value: UIColor?) -> Self {
        me.backgroundColor = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func layer(_ handler: ((Wrapper<CALayer>) -> Void)?) -> Self {
        handler?(me.layer.dtb)
        return self
    }
}

/// Same as ``@interface UIView(UIViewGeometry)``
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func frame(_ value: CGRect) -> Self {
        me.frame = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func bounds(_ value: CGRect) -> Self {
        me.bounds = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func center(_ value: CGPoint) -> Self {
        me.center = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func transform(_ value: CGAffineTransform) -> Self {
        me.transform = value
        return self
    }
    
    @available(iOS 13.0, *)
    @inline(__always)
    @discardableResult
    public func transform3D(_ value: CATransform3D) -> Self {
        me.transform3D = value
        return self
    }
    
    @available(iOS 16.0, *)
    @inline(__always)
    @discardableResult
    public func anchorPoint(_ value: CGPoint) -> Self {
        me.anchorPoint = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func isMultipleTouchEnabled(_ value: Bool) -> Self {
        me.isMultipleTouchEnabled = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func isExclusiveTouch(_ value: Bool) -> Self {
        me.isExclusiveTouch = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func autoresizesSubviews(_ value: Bool) -> Self {
        me.autoresizesSubviews = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func autoresizingMask(_ value: UIView.AutoresizingMask) -> Self {
        me.autoresizingMask = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func sizeThatFits(_ size: CGSize, setter: ((_ base: Base, _ result: CGSize) -> Void)) -> Self {
        setter(me, me.sizeThatFits(size))
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func sizeToFit() -> Self {
        me.sizeToFit()
        return self
    }
}

/// Same as ``@interface UIView(UIViewHierarchy)``
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func removeFromSuperview() -> Self {
        me.removeFromSuperview()
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func insertSubview(_ view: UIView, at index: Int) -> Self {
        me.insertSubview(view, at: index)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func exchangeSubview(at index1: Int, withSubviewAt index2: Int) -> Self {
        me.exchangeSubview(at: index1, withSubviewAt: index2)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func addSubview(_ view: UIView) -> Self {
        me.addSubview(view)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) -> Self {
        me.insertSubview(view, belowSubview: siblingSubview)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) -> Self {
        me.insertSubview(view, aboveSubview: siblingSubview)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func bringSubviewToFront(_ view: UIView) -> Self {
        me.bringSubviewToFront(view)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func sendSubviewToBack(_ view: UIView) -> Self {
        me.sendSubviewToBack(view)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func viewWithTag(_ tag: Int) -> Wrapper<UIView>? {
        return me.viewWithTag(tag)?.dtb
    }
    
    @inline(__always)
    @discardableResult
    public func setNeedsLayout() -> Self {
        me.setNeedsLayout()
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func layoutIfNeeded() -> Self {
        me.layoutIfNeeded()
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func layoutMargins(_ value: UIEdgeInsets) -> Self {
        me.layoutMargins = value
        return self
    }
    
    @available(iOS 11.0, *)
    @inline(__always)
    @discardableResult
    public func directionalLayoutMargins(_ value: NSDirectionalEdgeInsets) -> Self {
        me.directionalLayoutMargins = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func preservesSuperviewLayoutMargins(_ value: Bool) -> Self {
        me.preservesSuperviewLayoutMargins = value
        return self
    }
    
    @available(iOS 11.0, *)
    @inline(__always)
    @discardableResult
    public func insetsLayoutMarginsFromSafeArea(_ value: Bool) -> Self {
        me.insetsLayoutMarginsFromSafeArea = value
        return self
    }
}

/// Same as ``@interface UIView(UIViewRendering)``
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func setNeedsDisplay() -> Self {
        me.setNeedsDisplay()
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setNeedsDisplay(_ rect: CGRect) -> Self {
        me.setNeedsDisplay(rect)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func clipsToBounds(_ value: Bool) -> Self {
        me.clipsToBounds = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func alpha(_ value: CGFloat) -> Self {
        me.alpha = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func isOpaque(_ value: Bool) -> Self {
        me.isOpaque = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func clearsContextBeforeDrawing(_ value: Bool) -> Self {
        me.clearsContextBeforeDrawing = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func isHidden(_ value: Bool) -> Self {
        me.isHidden = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func contentMode(_ value: UIView.ContentMode) -> Self {
        me.contentMode = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func mask(_ value: UIView?) -> Self {
        me.mask = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func tintColor(_ value: UIColor) -> Self {
        me.tintColor = value
        return self
    }
    
    @inline(__always)
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
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func gestureRecognizers(_ value: [UIGestureRecognizer]?) -> Self {
        me.gestureRecognizers = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        me.addGestureRecognizer(gestureRecognizer)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func removeGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        me.removeGestureRecognizer(gestureRecognizer)
        return self
    }
}

/// Same as ``@interface UIView(UIViewMotionEffects)``
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func addMotionEffect(_ effect: UIMotionEffect) -> Self {
        me.addMotionEffect(effect)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func removeMotionEffect(_ effect: UIMotionEffect) -> Self {
        me.removeMotionEffect(effect)
        return self
    }
}

// UIConstraintBasedLayoutInstallingConstraints

/// Same as ``@interface UIView(UIConstraintBasedLayoutCoreMethods)``
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func setNeedsUpdateConstraints() -> Self {
        me.setNeedsUpdateConstraints()
        return self
    }
}

/// Same as ``@interface UIView(UIConstraintBasedCompatibility)``
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func translatesAutoresizingMaskIntoConstraints(_ value: Bool) -> Self {
        me.translatesAutoresizingMaskIntoConstraints = value
        return self
    }
}

/// Same as ``@interface UIView(UIConstraintBasedLayoutLayering)``
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func invalidateIntrinsicContentSize() -> Self {
        me.invalidateIntrinsicContentSize()
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        me.setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        me.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
}

/// Same as ``@interface UIView(UILayoutGuideSupport)``
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func addLayoutGuide(_ layoutGuide: UILayoutGuide) -> Self {
        me.addLayoutGuide(layoutGuide)
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func removeLayoutGuide(_ layoutGuide: UILayoutGuide) -> Self {
        me.removeLayoutGuide(layoutGuide)
        return self
    }
}

/// Same as ``@interface UIView (UISnapshotting)``
extension Wrapper where Base: UIView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        return me.snapshotView(afterScreenUpdates: afterUpdates)
    }
    
    @inline(__always)
    @discardableResult
    public func resizableSnapshotView(from rect: CGRect, afterScreenUpdates afterUpdates: Bool, withCapInsets capInsets: UIEdgeInsets) -> UIView? {
        return me.resizableSnapshotView(from: rect, afterScreenUpdates: afterUpdates, withCapInsets: capInsets)
    }
    
    @inline(__always)
    @discardableResult
    public func drawHierarchy(in rect: CGRect, afterScreenUpdates afterUpdates: Bool) -> Bool {
        return me.drawHierarchy(in: rect, afterScreenUpdates: afterUpdates)
    }
}

// UIViewLayoutConstraintCreation

// UIConstraintBasedLayoutDebugging

// UIStateRestoration

// UISnapshotting

// DeprecatedAnimations

// UserInterfaceStyle

// UIContentSizeCategoryLimit

