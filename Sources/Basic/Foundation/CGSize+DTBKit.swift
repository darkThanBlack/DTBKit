//
//  CGSize+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

/// All func needs (me.width >= 0) && (me.height >= 0)

/// Basic
extension DTBKitWrapper where Base == CGSize {
    
    /// W >= 0.0
    internal var width: CGFloat {
        return Swift.max(me.width, 0)
    }
    
    /// H >= 0.0
    internal var height: CGFloat {
        return Swift.max(me.height, 0)
    }
    
    /// W and H >= 0
    @discardableResult
    internal func safe() -> Self {
        return CGSize(width: width, height: height).dtb
    }
    
    /// W or H <= 0 | 长宽有一项小于等于 0
    public var isEmpty: Bool {
        return (me.width <= 0) || (me.height <= 0)
    }
    
    /// W == H | 是正方形
    public var isSquare: Bool {
        return isEmpty ? false : (me.width == me.height)
    }
    
    /// (W/2, H/2) | 中心点
    public var center: CGPoint {
        return CGPoint(x: width / 2.0, y: height / 2.0)
    }
    
    /// W * H | 面积
    public var area: CGFloat {
        return width * height
    }
    
    /// max(W, H) | 较长边
    public var longer: CGFloat {
        return Swift.max(width, height)
    }
    
    /// min(W, H) | 较短边
    public var shorter: CGFloat {
        return Swift.min(width, height)
    }
}

/// Flow box
extension DTBKitWrapper where Base == CGSize {
    
    /// Inscribe | 内接正方形
    public var inSquare: CGSize {
        return CGSize(width: shorter, height: shorter)
    }
    
    /// Circumscribe | 外接正方形
    public var outSquare: CGSize {
        return CGSize(width: longer, height: longer)
    }
    
    /// plus | (增加)外间距
    @discardableResult
    public func margin(all value: CGFloat) -> Self {
        return margin(dx: value, dy: value)
    }
    
    /// plus | (增加)外间距
    @discardableResult
    public func margin(dx: CGFloat, dy: CGFloat) -> Self {
        return margin(only: UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
    }
    
    /// plus | (增加)外间距
    @discardableResult
    public func margin(only insets: UIEdgeInsets) -> Self {
        return CGSize(
            width: width + insets.left + insets.right,
            height: height + insets.top + insets.bottom
        ).dtb.safe()
    }
    
    /// minus | (减少)内间距
    @discardableResult
    public func padding(all value: CGFloat) -> Self {
        return padding(dx: value, dy: value)
    }
    
    /// minus | (减少)内间距
    @discardableResult
    public func padding(dx: CGFloat, dy: CGFloat) -> Self {
        return padding(only: UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
    }
    
    /// minus | (减少)内间距
    @discardableResult
    public func padding(only insets: UIEdgeInsets) -> Self {
        return CGSize(
            width: width - (insets.left + insets.right),
            height: height - (insets.top + insets.bottom)
        ).dtb.safe()
    }
}

/// Aspect
extension DTBKitWrapper where Base == CGSize {
    
    /// Same as ``UIImageView.contentMode`` | 缩放，直至与 target 内接
    public func aspectFit(to target: CGSize) -> Self {
        if isEmpty || target.dtb.isEmpty {
            return CGSize.zero.dtb
        }
        let scaleX = target.width / me.width
        let scaleY = target.height / me.height
        let scale = Swift.min(scaleX, scaleY)
        return CGSize(width: me.width * scale, height: me.height * scale).dtb
    }
    
    /// Same as ``UIImageView.contentMode`` | 缩放，直至与 target 外接
    public func aspectFill(to target: CGSize) -> Self {
        if isEmpty || target.dtb.isEmpty {
            return CGSize.zero.dtb
        }
        let scaleX = target.width / me.width
        let scaleY = target.height / me.height
        let scale = Swift.max(scaleX, scaleY)
        return CGSize(width: me.width * scale, height: me.height * scale).dtb
    }
}
