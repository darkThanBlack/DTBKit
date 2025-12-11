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

/// high fidelity design
///
/// 高保真。
extension Wrapper where Base == CGRect {
    
    ///
    public func hf(_ behavior: DTB.HFBehaviors = .scale) -> CGRect {
        return CGRect(
            x: me.origin.x.dtb.hf(behavior),
            y: me.origin.y.dtb.hf(behavior),
            width: me.size.width.dtb.hf(behavior),
            height: me.size.height.dtb.hf(behavior)
        )
    }
}
