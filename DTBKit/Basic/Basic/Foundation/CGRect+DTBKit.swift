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

//Coordinate

/// Drift absorb
extension DTBKitWrapper where Base == CGRect {
    
    ///
    public func absorb(barrier: CGSize) -> CGRect {
        return CGRect(
            x: me.origin.x,
            y: me.origin.y,
            width: Swift.min(me.width, Swift.max(barrier.width, 0)),
            height: Swift.min(me.height, Swift.max(barrier.height, 0))
        )
    }
    
    ///
    public func inside(barrier: CGRect) -> CGRect {
        var newFrame = me
        
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
