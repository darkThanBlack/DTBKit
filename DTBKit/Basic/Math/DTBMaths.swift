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
    

import Foundation

extension DTBKitWrapper where Base == CGFloat {
    
    ///  x/0 -> x/1
    public func div(_ f: CGFloat) -> CGFloat {
        return mySelf / (f == 0.0 ? 1.0 : f)
    }
}

/// Size width and height always >= 0.0 semantically
extension DTBKit.DTBKitWrapper where Base == CGSize {
    
    // MARK: - basic
    
    ///
    public var isEmpty: Bool {
        return (mySelf.width <= 0) || (mySelf.height <= 0)
    }
    ///
    public var safe: CGSize {
        return CGSize(width: max(mySelf.width, 0), height: max(mySelf.height, 0))
    }
    ///
    public var center: CGPoint {
        return CGPoint(x: max(mySelf.width, 0) / 2.0, y: max(mySelf.height, 0) / 2.0)
    }
    ///
    public var longer: CGFloat {
        return max(max(mySelf.width, mySelf.height), 0)
    }
    ///
    public var shorter: CGFloat {
        return max(min(mySelf.width, mySelf.height), 0)
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
            width: mySelf.dtb.safe.width - (insets.left + insets.right),
            height: mySelf.dtb.safe.height - (insets.top + insets.bottom)
        ).dtb.safe
    }
    
    // MARK: - aspect
    
    ///
    public func aspectFit(to target: CGSize) -> CGSize {
        if isEmpty || target.dtb.isEmpty {
            return .zero
        }
        if mySelf.width > mySelf.height {
            return CGSize(
                width: target.width,
                height: target.width * mySelf.height / mySelf.width
            )
        } else {
            return CGSize(
                width: target.height * mySelf.width / mySelf.height,
                height: target.height
            )
        }
    }
    
    ///
    public func aspectFill(to target: CGSize) -> CGSize {
        if isEmpty || target.dtb.isEmpty {
            return .zero
        }
        
        if mySelf.width < mySelf.height {
            return CGSize(
                width: target.width,
                height: target.width * mySelf.height / mySelf.width
            )
        } else {
            return CGSize(
                width: target.height * mySelf.width / mySelf.height,
                height: target.height
            )
        }
    }
    
    // MARK: - other
    
    /// (W && H) <= S
    public func pureSmall(than s: CGSize) -> Bool {
        return (mySelf.width <= s.width) && (mySelf.height <= s.height)
    }
}
