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

///
extension Wrapper where Base: BinaryFloatingPoint {
    
    /// 截取小数后指定位数，默认四舍五入
    ///
    /// - Note: value must in [0, 15]
    @inline(__always)
    public func round(to value: Int = 0, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Double {
        let div = pow(10.0, Double(value))
        return (Double(me) * div).rounded(rule) / div
    }
    
    /// towardZero | 向 0 取整
    @inline(__always)
    public func trunc(to value: Int = 0) -> Double {
        return round(to: value, rule: .towardZero)
    }
    
    /// up | 向上取整
    @inline(__always)
    public func ceil(to value: Int = 0) -> Double {
        return round(to: value, rule: .up)
    }
    
    /// down | 向下取整
    @inline(__always)
    public func floor(to value: Int = 0) ->Double {
        return round(to: value, rule: .down)
    }
    
    /// 截取小数后指定位数，默认四舍五入
    ///
    /// - Note: value must in [0, 15]
    @inline(__always)
    public func rounded(to value: Int = 0, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Wrapper<Double> {
        return round(to: value, rule: rule).dtb
    }
    
    /// towardZero | 向 0 取整
    @inline(__always)
    public func truncated(to value: Int = 0) -> Wrapper<Double> {
        return rounded(to: value, rule: .towardZero)
    }
    
    /// up | 向上取整
    @inline(__always)
    public func ceiled(to value: Int = 0) -> Wrapper<Double> {
        return rounded(to: value, rule: .up)
    }
    
    /// down | 向下取整
    @inline(__always)
    public func floored(to value: Int = 0) -> Wrapper<Double> {
        return rounded(to: value, rule: .down)
    }
    
}
