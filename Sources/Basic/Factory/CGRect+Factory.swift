//
//  CGRect+Factory.swift
//  DTBKit
//
//  Created by moonShadow on 2024/7/19
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.StaticWrapper where T == CGRect {
    
    /// x | y | width | height
    @inline(__always)
    public func callAsFunction(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> T {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    @inline(__always)
    public func callAsFunction(origin: CGPoint = .zero, size: CGSize = .zero) -> T {
        return CGRect(origin: origin, size: size)
    }
}
