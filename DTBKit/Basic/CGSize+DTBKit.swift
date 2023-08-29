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

/// Size width and height always >= 0.0 semantically.
///
/// 从语义上来考虑，"大小" 的 "宽" 和 "高" 应当不小于 0，否则应该用 CGPoint 来实现。此处的代码均保证了这一点。
///
/// More info in ``MathTests.swift``
extension DTBKitWrapper where Base == CGSize {
    
    // MARK: - basic
    
    ///
    public var isEmpty: Bool {
        return (me.width <= 0) || (me.height <= 0)
    }
    ///
    public var safe: CGSize {
        guard isEmpty else {
            return me
        }
        return CGSize(width: max(me.width, 0), height: max(me.height, 0))
    }
    ///
    public var center: CGPoint {
        return CGPoint(x: max(me.width, 0) / 2.0, y: max(me.height, 0) / 2.0)
    }
    ///
    public var longer: CGFloat {
        return max(max(me.width, me.height), 0)
    }
    ///
    public var shorter: CGFloat {
        return max(min(me.width, me.height), 0)
    }
    
    // MARK: - flow box
    
    ///
    public var inSquare: CGSize {
        return CGSize(width: shorter, height: shorter)
    }
    ///
    public var outSquare: CGSize {
        return CGSize(width: longer, height: longer)
    }
    ///
    public func margin(all value: CGFloat) -> CGSize {
        return margin(dx: value, dy: value)
    }
    ///
    public func margin(dx: CGFloat, dy: CGFloat) -> CGSize {
        return margin(only: UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
    }
    ///
    public func margin(only insets: UIEdgeInsets) -> CGSize {
        return CGSize(
            width: safe.width + insets.left + insets.right,
            height: safe.height + insets.top + insets.bottom
        ).dtb.safe
    }
    ///
    public func padding(all value: CGFloat) -> CGSize {
        return padding(dx: value, dy: value)
    }
    ///
    public func padding(dx: CGFloat, dy: CGFloat) -> CGSize {
        return padding(only: UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
    }
    ///
    public func padding(only insets: UIEdgeInsets) -> CGSize {
        return CGSize(
            width: me.dtb.safe.width - (insets.left + insets.right),
            height: me.dtb.safe.height - (insets.top + insets.bottom)
        ).dtb.safe
    }
    
    // MARK: - aspect
    
    /// Same as ``UIImageView.contentMode``
    public func aspectFit(to target: CGSize) -> CGSize {
        if isEmpty || target.dtb.isEmpty {
            return .zero
        }
        if me.width > me.height {
            return CGSize(
                width: target.width,
                height: target.width * me.height / me.width
            )
        } else {
            return CGSize(
                width: target.height * me.width / me.height,
                height: target.height
            )
        }
    }
    
    /// Same as ``UIImageView.contentMode``
    public func aspectFill(to target: CGSize) -> CGSize {
        if isEmpty || target.dtb.isEmpty {
            return .zero
        }
        
        if me.width < me.height {
            return CGSize(
                width: target.width,
                height: target.width * me.height / me.width
            )
        } else {
            return CGSize(
                width: target.height * me.width / me.height,
                height: target.height
            )
        }
    }
    
    // MARK: - other
    
    /// (W && H) <= S
    public func pureSmall(than s: CGSize) -> Bool {
        return (me.width <= s.width) && (me.height <= s.height)
    }
}
