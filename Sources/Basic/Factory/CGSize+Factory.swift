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

extension StaticWrapper where T == CGSize {
    
    /// width | height
    @inline(__always)
    public func callAsFunction(_ width: CGFloat, _ height: CGFloat) -> T {
        return CGSize(width: width, height: height)
    }
    
    @inline(__always)
    public func callAsFunction(width: CGFloat = 0, height: CGFloat = 0) -> T {
        return CGSize(width: width, height: height)
    }
    
    @inline(__always)
    public func callAsFunction(square: CGFloat) -> T {
        return CGSize(width: square, height: square)
    }
}
