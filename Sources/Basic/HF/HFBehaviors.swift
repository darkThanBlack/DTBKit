//
//  HFBehaviors.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/18
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// hf means "high fidelity" | 高保真
    ///
    ///
    public struct HFBehaviors {
        
        public let handler: ((CGFloat) -> CGFloat)
        
        public init(handler: @escaping ((CGFloat) -> CGFloat)) {
            self.handler = handler
        }
    }
}

extension DTB.HFBehaviors {
    
    /// 默认按设计图宽度等比缩放；参见 ``DTB.Performance.designBaseSize``
    @inline(__always)
    public static func scale(_ axis: DTB.Axis = .h) -> Self {
        return DTB.HFBehaviors { v in
            switch axis {
            case .h:
                return v * UIScreen.main.bounds.size.width / DTB.config.designBaseSize.width
            case .v:
                return v * UIScreen.main.bounds.size.height / DTB.config.designBaseSize.height
            }
        }
    }
}
