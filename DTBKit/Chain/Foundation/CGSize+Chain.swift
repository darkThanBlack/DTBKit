//
//  CGSize+Chain.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/7
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension CGSize: DTBKitStructable {}

extension DTBKitStaticWrapper where T == CGSize {
    
    /// width | height
    public func create(_ width: CGFloat, _ height: CGFloat) -> T {
        return CGSize(width: width, height: height)
    }
    
    public func create(_ square: CGFloat) -> T {
        return CGSize(width: square, height: square)
    }
}
