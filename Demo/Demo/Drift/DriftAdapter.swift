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
        return DTBKitWrapper(named: name, bundleName: "DTBKit-UIKit", frameworkName: "DTBKit")?.value
    }
    
    static func makeToast(_ message: String?) {
        print("toast:  \(message ?? "")")
    }
    
    static func color_999999() -> UIColor {
        return XMVisual.Color.LightGray.A
    }
    
    static func color_666666() -> UIColor {
        return XMVisual.Color.Gray.A
    }
    
    static func color_333333() -> UIColor {
        return XMVisual.Color.DarkGray.A
    }
    
    static func color_FAFAFA() -> UIColor {
        return XMVisual.Color.White.I
    }
    
    static func color_FF8534() -> UIColor {
        return XMVisual.Color.Orange.A
    }
    
    static func color_FFAB1A() -> UIColor {
        return XMVisual.Color.Orange.B
    }
    
    static func color_FFF0E7() -> UIColor {
        return UIColor.dtb.hex(0xFFF0E7)
    }
}
