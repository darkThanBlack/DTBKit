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

extension Wrapper where Base == CGSize {
    
    /// High fidelity design | 高保真
    @inline(__always)
    public func hf(_ behavior: DTB.HFBehaviors = .scale) -> CGSize {
        return CGSize(
            width: me.width.dtb.hf(behavior),
            height: me.height.dtb.hf(behavior)
        )
    }
}

extension Wrapper where Base == CGRect {
    
    /// High fidelity design | 高保真
    public func hf(_ behavior: DTB.HFBehaviors = .scale) -> CGRect {
        return CGRect(
            x: me.origin.x.dtb.hf(behavior),
            y: me.origin.y.dtb.hf(behavior),
            width: me.size.width.dtb.hf(behavior),
            height: me.size.height.dtb.hf(behavior)
        )
    }
}

/// High fidelity design
///
/// 高保真。
extension Wrapper where Base: BinaryFloatingPoint {
    
    /// High fidelity design | 高保真
    ///
    /// more detail in ``HFBehaviors``
    @inline(__always)
    public func hf(_ behavior: DTB.HFBehaviors = .scale) -> CGFloat {
        switch behavior {
        case .scale:
            return CGFloat(me) * UIScreen.main.bounds.size.width / DTB.Configuration.shared.designBaseSize.width
        }
    }
}
