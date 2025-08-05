//
//  UIColor+Chain.swift
//  XMKit
//
//  Created by moonShadow on 2023/10/2
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension StaticWrapper where T: UIColor {
    
    /// 0xRRGGBB
    public func hex(_ value: Int64, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(value & 0xFF) / 255.0,
            alpha: alpha
        )
    }
    
    /// RRGGBB / "#RRGGBB" / "0xRRGGBB"
    public func hex(_ value: String?, alpha: CGFloat = 1.0) -> UIColor? {
        guard let upper = value?.uppercased()
            .replacingOccurrences(of: "^#", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^0X", with: "", options: .regularExpression),
              upper.count == 6 else {
            return nil
        }
        
        guard let r = Int(upper.prefix(2), radix: 16),
              let g = Int(upper.dropFirst(2).prefix(2), radix: 16),
              let b = Int(upper.dropFirst(4).prefix(2), radix: 16) else {
            return nil
        }
        
        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: alpha
        )
    }
    
    /// 0xAARRGGBB
    public func hex(argb value: Int64) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0x00FF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x0000FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x000000FF) / 255.0,
            alpha: CGFloat((value & 0xFF000000) >> 24) / 255.0
        )
    }
    
    /// AARRGGBB / "#AARRGGBB" / "0xAARRGGBB"
    public func hex(argb value: String?) -> UIColor? {
        guard let upper = value?.uppercased()
            .replacingOccurrences(of: "^#", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^0X", with: "", options: .regularExpression),
              upper.count == 8 else {
            return nil
        }
        
        guard let a = Int(upper.prefix(2), radix: 16),
              let r = Int(upper.dropFirst(2).prefix(2), radix: 16),
              let g = Int(upper.dropFirst(4).prefix(2), radix: 16),
              let b = Int(upper.dropFirst(6).prefix(2), radix: 16) else {
            return nil
        }
        
        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    /// 0xRRGGBBAA
    public func hex(rgba value: Int64) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0xFF000000) >> 24) / 255.0,
            green: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            blue: CGFloat((value & 0xFF00) >> 8) / 255.0,
            alpha: CGFloat(value & 0xFF) / 255.0
        )
    }
    
    /// RRGGBBAA / "#RRGGBBAA" / "0xRRGGBBAA"
    public func hex(rgba value: String?) -> UIColor? {
        guard let upper = value?.uppercased()
            .replacingOccurrences(of: "^#", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^0X", with: "", options: .regularExpression),
              upper.count == 8 else {
            return nil
        }
        
        guard let r = Int(upper.prefix(2), radix: 16),
              let g = Int(upper.dropFirst(2).prefix(2), radix: 16),
              let b = Int(upper.dropFirst(4).prefix(2), radix: 16),
              let a = Int(upper.dropFirst(6).prefix(2), radix: 16) else {
            return nil
        }
        
        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
}
