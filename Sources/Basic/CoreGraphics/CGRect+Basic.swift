//
//  DTBMaths.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Wrapper where Base == CGRect {

    @inline(__always)
    public func safe() -> Self {
        return me.standardized.dtb
    }

    @inline(__always)
    @discardableResult
    public func margin(all value: CGFloat) -> Self {
        return margin(dx: value, dy: value)
    }

    @inline(__always)
    @discardableResult
    public func margin(dx: CGFloat, dy: CGFloat) -> Self {
        return margin(only: UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
    }

    @inline(__always)
    @discardableResult
    public func margin(only insets: UIEdgeInsets) -> Self {
        return CGRect(
            x: me.origin.x - insets.left,
            y: me.origin.y - insets.top,
            width: max(0, me.width) + insets.left + insets.right,
            height: max(0, me.height) + insets.top + insets.bottom
        ).dtb
    }

    @inline(__always)
    @discardableResult
    public func padding(all value: CGFloat) -> Self {
        return padding(dx: value, dy: value)
    }

    @inline(__always)
    @discardableResult
    public func padding(dx: CGFloat, dy: CGFloat) -> Self {
        return padding(only: UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
    }

    @inline(__always)
    @discardableResult
    public func padding(only insets: UIEdgeInsets) -> Self {
        return CGRect(
            x: me.origin.x + insets.left,
            y: me.origin.y + insets.top,
            width: max(0, max(0, me.width) - (insets.left + insets.right)),
            height: max(0, max(0, me.height) - (insets.top + insets.bottom))
        ).dtb
    }
}
