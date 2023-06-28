//
//  UIColor+DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

extension DTB {
    
    ///
    public enum Color {
        /// Darkable hex color
        ///
        /// sample: 0xFF8534 -> UIColor
        public static func hex(_ def: Int64, alpha: CGFloat = 1.0, dark: Int64? = nil, darkAlpha: CGFloat? = nil) -> UIColor {
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
}
