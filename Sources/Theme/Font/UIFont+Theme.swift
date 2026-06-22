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
        if let p = DTB.Providers.get(DTB.Providers.fontKey), let font = p.create(param) {
            return font
        }
        if let size = param as? Double {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        if let style = param as? DTB.FontStyle, let font = style.getFont() {
            return font
        }
        if let dict = param as? [String: Any], let style = DTB.FontStyle(dict: dict), let font = style.getFont() {
            return font
        }
        DTB.console.error("font: create failed by param=\(param ?? "")")
        return .systemFont(ofSize: 15.0)
    }
    
    /// Create font with provider.
    ///
    /// 字体调用收束
    @inline(__always)
    public func create(size: CGFloat, weight: UIFont.Weight = .regular, name: String? = nil) -> UIFont {
        return create([
            "size": size,
            "weight": weight,
            "name": name ?? ""
        ])
    }
}

extension StaticWrapper where T == UIFont.Weight {
    
    public func create(_ param: Any?) -> UIFont.Weight? {
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
        if let raw = param as? CGFloat {
            return UIFont.Weight(raw)
        }
        return nil
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
