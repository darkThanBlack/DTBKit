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

extension DTBKitWrapper where Base == CGFloat {
    
    ///  x/0 -> x/1
    public func div(_ f: CGFloat) -> CGFloat {
        return me / (f == 0.0 ? 1.0 : f)
    }
}

/// Size width and height always >= 0.0 semantically
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
    
    ///
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
    
    ///
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

extension DTBKitWrapper where Base == CGRect {
    
    //MARK: - absorb
    
    public var isEmpty: Bool {
        return me.size.dtb.isEmpty
    }
    
    public func absorbable(in barrier: CGSize) -> CGRect {
        return CGRect(
            x: me.origin.x,
            y: me.origin.y,
            width: min(me.width, max(barrier.width, 0)),
            height: min(me.height, max(barrier.height, 0))
        )
    }
    
//    public func absorbInside(in barrier: CGSize) -> CGRect {
//        var result = absorbable(in: barrier)
//
//    }
    
    func frameInside(value: CGRect, barrier: CGRect) -> CGRect {
        var newFrame = value
        
        if newFrame.origin.x < 0 {
            newFrame.origin.x = 0
        }
        
        if newFrame.origin.x > (barrier.size.width - newFrame.size.width) {
            newFrame.origin.x = barrier.size.width - newFrame.size.width
        }
        
        if newFrame.origin.y < 0 {
            newFrame.origin.y = 0
        }
        
        if newFrame.origin.y > (barrier.size.height - newFrame.size.height) {
            newFrame.origin.y = barrier.size.height - newFrame.size.height
        }
        
        return newFrame
    }
    
}
