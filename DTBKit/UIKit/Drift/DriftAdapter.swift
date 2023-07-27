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
        return DTBKitWrapper(named: name, bundleName: "DTBKit-UIKit", frameworkName: "DTBKit")?.me
    }
    
    static func color_333333() -> UIColor {
        return Color.XM.DarkGray.A
    }
    
    static func color_FF8534() -> UIColor {
        return Color.XM.Orange.A
    }
    
    static func color_FFAB1A() -> UIColor {
        return Color.XM.Orange.B
    }
    
}
