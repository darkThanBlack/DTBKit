//
//  UIColor+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2023/10/2
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// See more details in ``dtbkit_adapter.md``
public protocol DTBKitAdapterForUIColor {
    
    associatedtype ColorParam = Int64
    
    /// Color generate | 色值生成收口
    ///
    /// 便于处理 暗黑模式 / 主题色 等需求
    func create(_ key: ColorParam) -> UIColor
}

extension DTBKitAdapterForUIColor where ColorParam == Int64 {
    
    public func create(_ key: ColorParam) -> UIColor {
        return UIColor.dtb.hex(key)
    }
}

extension DTBKitStaticWrapper where T: UIColor {
    
    /// hex -> color
    ///
    /// e.g. ``label.textColor = .dtb.hex(0xFF8534)``
    public func hex(_ def: Int64, alpha: CGFloat = 1.0, dark: Int64? = nil, darkAlpha: CGFloat? = nil) -> UIColor {
        ///
        func actual(hex: Int64, a: CGFloat) -> UIColor {
            return UIColor(
                red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
                blue: CGFloat(hex & 0xFF) / 255.0,
                alpha: a
            )
        }
        
        if #available(iOS 13.0, *) {
            return UIColor.init { (traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .unspecified, .light:
                    return actual(hex: def, a: alpha)
                case .dark:
                    return actual(hex: dark ?? def, a: darkAlpha ?? alpha)
                @unknown default:
                    return actual(hex: def, a: alpha)
                }
            }
        }
        return actual(hex: def, a: alpha)
    }
}
