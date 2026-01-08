//
//  UIFont+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/10/9
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension Wrapper where Base == UIFont.Weight {
    
    /// Rule: fontname-variant.extension
    public func variant() -> String {
        switch me.rawValue {
        case UIFont.Weight.ultraLight.rawValue: return "UltraLight"
        case UIFont.Weight.thin.rawValue:       return "Thin"
        case UIFont.Weight.light.rawValue:      return "Light"
        case UIFont.Weight.regular.rawValue:    return "Regular"
        case UIFont.Weight.medium.rawValue:     return "Medium"
        case UIFont.Weight.semibold.rawValue:   return "Semibold"
        case UIFont.Weight.bold.rawValue:       return "Bold"
        case UIFont.Weight.heavy.rawValue:      return "Heavy"
        case UIFont.Weight.black.rawValue:      return "Black"
        default: return String(format: "%.0f", me.rawValue)
        }
    }
}
