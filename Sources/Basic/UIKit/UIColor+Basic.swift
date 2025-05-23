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

extension StaticWrapper where T: UIColor {
    
    /// 0xFF8534 -> UIColor
    public func hex(_ value: Int64, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(value & 0xFF) / 255.0,
            alpha: alpha
        )
    }
    
    /// hex -> color
    ///
    /// e.g. ``label.textColor = .dtb.hex(0xFF8534)``
//    public func hex(_ def: Int64, alpha: CGFloat = 1.0, dark: Int64? = nil, darkAlpha: CGFloat? = nil) -> UIColor {
//        ///
//        func actual(hex: Int64, a: CGFloat) -> UIColor {
//            return UIColor(
//                red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
//                green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
//                blue: CGFloat(hex & 0xFF) / 255.0,
//                alpha: a
//            )
//        }
//        
//        if #available(iOS 13.0, *) {
//            return UIColor.init { (traitCollection) -> UIColor in
//                switch traitCollection.userInterfaceStyle {
//                case .unspecified, .light:
//                    return actual(hex: def, a: alpha)
//                case .dark:
//                    return actual(hex: dark ?? def, a: darkAlpha ?? alpha)
//                @unknown default:
//                    return actual(hex: def, a: alpha)
//                }
//            }
//        }
//        return actual(hex: def, a: alpha)
//    }
}
