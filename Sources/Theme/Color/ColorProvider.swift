//
//  DTBKitColor.swift
//  DTBKit
//
//  Created by moonShadow on 2023/12/28
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Providers {
    
    public static let colorKey = DTB.ConstKey<any ColorProvider>("dtb.providers.color")
    
    ///
    public protocol ColorProvider {
        
        func create(_ param: Any?) -> UIColor
    }
}


extension StaticWrapper where T: UIColor {
    
    /// Create color with provider.
    ///
    /// 颜色调用收束
    @inline(__always)
    public func create(_ param: Any?) -> UIColor {
        return DTB.Providers.get(DTB.Providers.colorKey)?.create(param) ?? .black
    }
}
