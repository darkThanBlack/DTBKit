//
//  DiskUsageDepends.swift
//  Setting
//
//  Created by moonShadow on 2025/7/18
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

class DiskUsageDepends {
    
    ///
    static func appName() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? "本应用"
    }
    
    static func fakeZeroSize() -> Int64 {
        return 200 * 1024
    }
    
    ///
    static func minUsedPercent() -> CGFloat {
        return 0.01
    }
    
    ///
    static func backgroundColor() -> UIColor {
        // F5F7FA
        return UIColor(red: 245/255.0, green: 247/255.0, blue: 250/255.0, alpha: 1.0)
    }
    
    ///
    static func themeColor() -> UIColor {
        // F05746
        return .dtb.create("danger")
    }
    
    ///
    static func textColor() -> UIColor {
        // 15171F
        return UIColor(red: 21/255.0, green: 23/255.0, blue: 31/255.0, alpha: 1.0)
    }
    
    ///
    static func lightTextColor() -> UIColor {
        // 73778C
        return UIColor(red: 115/255.0, green: 119/255.0, blue: 140/255.0, alpha: 1.0)
    }
    
    ///
    static func buttonTitleColor() -> UIColor {
        // FFFFFF
        return UIColor.white
    }
    
    ///
    static func progressUsedColor() -> UIColor {
        // ABABAB
        return .lightGray
    }
    
    ///
    static func progressFreeColor() -> UIColor {
        // EEF0F7
        return UIColor(red: 238/255.0, green: 240/255.0, blue: 247/255.0, alpha: 1.0)
    }
}
