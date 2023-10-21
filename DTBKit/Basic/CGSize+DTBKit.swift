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

// Size width and height will always >= 0.0 semantically.
//
// Uni test: ``MathTests.swift``

/// Basic
extension DTBKitWrapper where Base == CGSize {
    
    /// >= 0.0
    public var width: CGFloat {
        return Swift.max(me.width, 0)
    }
    
    /// >= 0.0
    public var height: CGFloat {
        return Swift.max(me.height, 0)
    }
    
    /// width & height >= 0
    @discardableResult
    public func safe() -> Self {
        guard isEmpty else { return self }
        return CGSize(width: width, height: height).dtb
    }
    
    ///
    public var isEmpty: Bool {
        return (width == 0) || (height == 0)
    }
    
    ///
    public var isSquare: Bool {
        return width == height
    }
    
    ///
    public var center: CGPoint {
        return CGPoint(x: width / 2.0, y: height / 2.0)
    }
    
    ///
    public var area: CGFloat {
        return width * height
    }
    
    ///
    public var longer: CGFloat {
        return Swift.max(width, height)
    }
    
    ///
    public var shorter: CGFloat {
        return Swift.min(width, height)
    }
}

/// Flow box
extension DTBKitWrapper where Base == CGSize {
    
    /// Inscribe
    public var inSquare: CGSize {
        return CGSize(width: shorter, height: shorter)
    }
    
    /// Circumscribe
    public var outSquare: CGSize {
        return CGSize(width: longer, height: longer)
    }
    
    ///
    @discardableResult
    public func margin(all value: CGFloat) -> Self {
        return margin(dx: value, dy: value)
    }
    
    ///
    @discardableResult
    public func margin(dx: CGFloat, dy: CGFloat) -> Self {
        return margin(only: UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
    }
    
    ///
    @discardableResult
    public func margin(only insets: UIEdgeInsets) -> Self {
        return CGSize(
            width: width + insets.left + insets.right,
            height: height + insets.top + insets.bottom
        ).dtb.safe()
    }
    
    ///
    @discardableResult
    public func padding(all value: CGFloat) -> Self {
        return padding(dx: value, dy: value)
    }
    
    ///
    @discardableResult
    public func padding(dx: CGFloat, dy: CGFloat) -> Self {
        return padding(only: UIEdgeInsets(top: dy, left: dx, bottom: dy, right: dx))
    }
    
    ///
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
    
    /// Same as ``UIImageView.contentMode``
    public func aspectFit(to target: CGSize) -> Self {
        if isEmpty || target.dtb.isEmpty {
            return CGSize.zero.dtb
        }
        if me.width > me.height {
            return CGSize(
                width: target.width,
                height: target.width * me.height / me.width
            ).dtb
        } else {
            return CGSize(
                width: target.height * me.width / me.height,
                height: target.height
            ).dtb
        }
    }
    
    /// Same as ``UIImageView.contentMode``
    public func aspectFill(to target: CGSize) -> Self {
        if isEmpty || target.dtb.isEmpty {
            return CGSize.zero.dtb
        }
        
        if me.width < me.height {
            return CGSize(
                width: target.width,
                height: target.width * me.height / me.width
            ).dtb
        } else {
            return CGSize(
                width: target.height * me.width / me.height,
                height: target.height
            ).dtb
        }
    }
}
