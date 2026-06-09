//
//  RoundCornerStyle.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/9
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// 对称型圆角 (radii width == height)
    public enum CornerRadiusStyle: Equatable {
        
        case none
        
        ///
        case fixed(CGFloat)
        
        /// 不是定值，而是 view.bounds.width 的百分比, 取值为 [0, 1]
        ///
        /// e.g. 你需要圆角为 width 的一半, 但是 view.width 又可能动态变化，这时就可以通过传 0.5 来解决
        case scaledToWidth(CGFloat)
        
        /// 不是定值，而是 view.bounds.height 的百分比, 取值为 [0, 1]
        ///
        /// e.g. 你需要圆角为 height 的一半, 但是 view.height 又可能动态变化，这时就可以通过传 0.5 来解决
        case scaledToHeight(CGFloat)
        
        ///
        public func radii(for bounds: CGRect? = nil) -> CGSize {
            switch self {
            case .none:
                return .zero
            case .fixed(let value):
                return CGSize(width: value, height: value)
            case .scaledToWidth(let value):
                return CGSize(
                    width: value * (bounds?.size.width ?? 0),
                    height: value * (bounds?.size.width ?? 0)
                )
            case .scaledToHeight(let value):
                return CGSize(
                    width: value * (bounds?.size.height ?? 0),
                    height: value * (bounds?.size.height ?? 0)
                )
            }
        }
    }
}
