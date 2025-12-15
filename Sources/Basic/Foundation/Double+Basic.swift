//
//  CGFloat+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    
import UIKit
import Foundation

extension Wrapper where Base: BinaryFloatingPoint {
    
    ///
    @inline(__always)
    public func rounded(_ roundRule: FloatingPointRoundingRule? = nil) -> Self {
        if let rule = roundRule {
            return Wrapper(me.rounded(rule))
        }
        return Wrapper(me.rounded())
    }
}

///
extension Wrapper where Base: BinaryFloatingPoint {
    
    /// Cut dicimal places.
    ///
    /// 截取小数后 x 位。
    ///
    /// Example: ``1.26.dtb.place(1).value = 1.2``
    @inline(__always)
    public func places(_ value: Int) -> Double {
        let div = pow(10.0, Double(value))
        return ((Double(me) * div).rounded(.down) / div)
    }
}
