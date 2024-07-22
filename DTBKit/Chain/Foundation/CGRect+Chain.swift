//
//  CGRect+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/7/19
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTBKitStaticWrapper where T == CGRect {
    
    /// x | y | width | height
    public func create(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> T {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    public func create(origin: CGPoint = .zero, size: CGSize) -> T {
        return CGRect(origin: origin, size: size)
    }
}
