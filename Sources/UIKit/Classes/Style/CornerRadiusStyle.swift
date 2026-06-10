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
        
        /// 从任意类型解析圆角样式
        /// 支持格式：
        /// - 纯数字 → .fixed(value)
        /// - 字典 { "type": "fixed"|"width"|"height", "value": CGFloat }
        public init?(param: Any?) {
            guard let param = param else { return nil }
            
            // 1. 纯数字
            if let value = param as? CGFloat {
                self = .fixed(value)
                return
            }
            
            // 2. 字典结构
            guard let dict = param as? [String: Any] else {
                return nil
            }
            if let fixed = dict["fixed"] as? CGFloat {
                self = .fixed(fixed)
            }
            if let scaledToWidth = dict["scaledToWidth"] as? CGFloat {
                self = .scaledToWidth(scaledToWidth)
            }
            if let scaledToHeight = dict["scaledToHeight"] as? CGFloat {
                self = .scaledToHeight(scaledToHeight)
            }
            return nil
        }
        
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
