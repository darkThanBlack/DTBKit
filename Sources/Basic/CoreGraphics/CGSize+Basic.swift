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

/// Basic
extension Wrapper where Base == CGSize {
    
    /// W & H >= 0 | 将负数长宽改为 0
    @inline(__always)
    public func safe() -> Self {
        return CGSize(width: max(0, me.width), height: max(0, me.height)).dtb
    }
    
    /// W or H <= 0 | 长宽有一项小于等于 0
    @inline(__always)
    public func isEmpty() -> Bool {
        return (me.width <= 0) || (me.height <= 0)
    }
    
    /// W and H > 0
    @inline(__always)
    public func notEmpty() -> Bool {
        return !isEmpty()
    }
    
    /// W == H | 是正方形
    @inline(__always)
    public func isSquare() -> Bool {
        return isEmpty() ? false : (me.width == me.height)
    }
    
    /// (W/2, H/2) | 中心点
    @inline(__always)
    public func center() -> CGPoint {
        return CGPoint(x: max(0, me.width) / 2.0, y: max(0, me.height) / 2.0)
    }
    
    /// W * H | 面积
    @inline(__always)
    public func area() -> CGFloat {
        return max(0, me.width) * max(0, me.height)
    }
    
    /// max(W, H) | 较长边
    @inline(__always)
    public func longer() -> CGFloat {
        return max(0, max(me.width, me.height))
    }
    
    /// min(W, H) | 较短边
    @inline(__always)
    public func shorter() -> CGFloat {
        return max(0, min(me.width, me.height))
    }
}

/// Flow box
extension Wrapper where Base == CGSize {
    
    /// Inscribe | 内接正方形
    @inline(__always)
    public func inSquare() -> Self {
        return CGSize(width: shorter(), height: shorter()).dtb
    }
    
    /// Circumscribe | 外接正方形
    @inline(__always)
    public func outSquare() -> Self {
        return CGSize(width: longer(), height: longer()).dtb
    }
    
    /// plus | (增加)外间距
    @inline(__always)
    @discardableResult
    public func margin(all value: CGFloat) -> Self {
        return margin(dx: value, dy: value)
    }
    
    /// plus | (增加)外间距
    @inline(__always)
    @discardableResult
    public func margin(dx: CGFloat, dy: CGFloat) -> Self {
        return margin(only: UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
    }
    
    /// plus | (增加)外间距
    @inline(__always)
    @discardableResult
    public func margin(only insets: UIEdgeInsets) -> Self {
        return CGSize(
            width: max(0, max(0, me.width) + (insets.left + insets.right)),
            height: max(0, max(0, me.height) + (insets.top + insets.bottom))
        ).dtb
    }
    
    /// minus | (减少)内间距
    @inline(__always)
    @discardableResult
    public func padding(all value: CGFloat) -> Self {
        return padding(dx: value, dy: value)
    }
    
    /// minus | (减少)内间距
    @inline(__always)
    @discardableResult
    public func padding(dx: CGFloat, dy: CGFloat) -> Self {
        return padding(only: UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
    }
    
    /// minus | (减少)内间距
    @inline(__always)
    @discardableResult
    public func padding(only insets: UIEdgeInsets) -> Self {
        return CGSize(
            width: max(0, max(0, me.width) - (insets.left + insets.right)),
            height: max(0, max(0, me.height) - (insets.top + insets.bottom))
        ).dtb
    }
}

/// Aspect
extension Wrapper where Base == CGSize {
    
    /// Same as ``UIImageView.contentMode`` | 缩放，直至与 target 内接
    public func aspectFit(to target: CGSize) -> Self {
        if isEmpty()  { return target.dtb }
        if target.dtb.isEmpty()  { return CGSize.zero.dtb }
        let scaleX = target.width / me.width
        let scaleY = target.height / me.height
        let scale = Swift.min(scaleX, scaleY)
        return CGSize(width: me.width * scale, height: me.height * scale).dtb
    }
    
    /// Same as ``UIImageView.contentMode`` | 缩放，直至与 target 外接
    public func aspectFill(to target: CGSize) -> Self {
        if isEmpty()  { return target.dtb }
        if target.dtb.isEmpty()  { return CGSize.zero.dtb }
        let scaleX = target.width / me.width
        let scaleY = target.height / me.height
        let scale = Swift.max(scaleX, scaleY)
        return CGSize(width: me.width * scale, height: me.height * scale).dtb
    }
}
