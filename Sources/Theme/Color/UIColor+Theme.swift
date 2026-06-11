//
//  UIColor+Theme.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension StaticWrapper where T: UIColor {
    
    /// Create color with provider.
    ///
    /// 颜色调用收束
    @inline(__always)
    public func create(_ param: Any?) -> UIColor {
        if let p = DTB.Providers.get(DTB.Providers.colorKey), let result = p.create(param) {
            return result
        }
        if let s = param as? String {
            return .dtb.percentHex(s)
        }
        if let i = param as? Int64 {
            return .dtb.hex(i)
        }
        return .clear
    }
}
