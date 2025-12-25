//
//  HighFidelityDesign+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/12
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: FixedWidthInteger & SignedInteger {
    
    /// High fidelity design | 高保真
    ///
    /// more detail in ``HFBehaviors``
    @inline(__always)
    public func hf(_ behavior: DTB.HFBehaviors = .scale()) -> CGFloat {
        return double().hf(behavior)
    }
}

extension Wrapper where Base: BinaryFloatingPoint {
    
    /// High fidelity design | 高保真
    ///
    /// more detail in ``HFBehaviors``
    @inline(__always)
    public func hf(_ behavior: DTB.HFBehaviors = .scale()) -> CGFloat {
        return behavior.handler(doubleValue())
    }
}
