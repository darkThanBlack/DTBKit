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

extension StaticWrapper where T: UIFont {
    
    /// Create font with provider.
    ///
    /// 字体调用收束
    @inline(__always)
    public func create(_ param: Any?) -> UIFont {
        return DTB.Providers.get(DTB.Providers.fontKey)?.create(param) ?? UIFont.systemFont(ofSize: 17.0)
    }
    
    /// Create font with provider.
    ///
    /// 字体调用收束
    @inline(__always)
    public func create(_ size: CGFloat, weight: UIFont.Weight = .regular, name: String? = nil) -> UIFont {
        return DTB.Providers.get(DTB.Providers.fontKey)?.create(
            [
                "name": name ?? "",
                "size": size,
                "weight": weight
            ]
        ) ?? UIFont.systemFont(ofSize: 17.0)
    }
}

extension StaticWrapper where T == UIFont.Weight {
    
    public func create(_ param: Any?) -> UIFont.Weight {
        if let variant = param as? String {
            switch variant.lowercased() {
            case  "ultralight":  return UIFont.Weight.ultraLight
            case  "thin":        return UIFont.Weight.thin
            case  "light":       return UIFont.Weight.light
            case  "regular":     return UIFont.Weight.regular
            case  "medium":      return UIFont.Weight.medium
            case  "semibold":    return UIFont.Weight.semibold
            case  "bold":        return UIFont.Weight.bold
            case  "heavy":       return UIFont.Weight.heavy
            case  "black":       return UIFont.Weight.black
            default:
                break
            }
        }
        DTB.console.error("UIFont.Weight create failed, param=\(param ?? "")")
        return .regular
    }
}

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
