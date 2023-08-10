//
//  DriftAdapter.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/24
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

class DriftAdapter {
    
    static func imageNamed(_ name: String) -> UIImage? {
//        return DTBKitWrapper(named: name, bundleName: "DTBKit-UIKit", frameworkName: "DTBKit")?.me
        return UIImage(named: name)
    }
    
    static func color_999999() -> UIColor {
//        return Color.XM.LightGray.A
        return XMVisual.Color.LightGray.A
    }
    
    static func color_666666() -> UIColor {
//        return Color.XM.Gray.A
        return XMVisual.Color.Gray.A
    }
    
    static func color_333333() -> UIColor {
//        return Color.XM.DarkGray.A
        return XMVisual.Color.DarkGray.A
    }
    
    static func color_FAFAFA() -> UIColor {
//        return Color.XM.White.I
        return XMVisual.Color.White.I
    }
    
    static func color_FF8534() -> UIColor {
//        return Color.XM.Orange.A
        return XMVisual.Color.Orange.A
    }
    
    static func color_FFAB1A() -> UIColor {
//        return Color.XM.Orange.B
        return XMVisual.Color.Orange.B
    }
    
    static func color_FFF0E7() -> UIColor {
//        return Color.hex(0xFFF0E7)
        return XMVisual.Color.Orange.L
    }
}
