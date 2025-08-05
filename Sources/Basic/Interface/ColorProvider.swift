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

/// 
public protocol ColorProvider {
    
    func create(_ param: Any?) -> UIColor?
}

extension StaticWrapper where T: UIColor {
    
    /// Create color with provider.
    ///
    /// 颜色调用收束
    public func create(_ param: Any?) -> UIColor {
        if let color = DTB.app.get(DTB.BasicInterface.colorKey)?.create(param) {
            return color
        }
        
        if let i: Int64 = {
            if let v = param as? Int { return Int64(v) }
            if let v = param as? Int64 { return v }
            return nil
        }() {
            return .dtb.hex(i)
        }
        if let s = param as? String,
           let result = UIColor.dtb.hex(s) {
            return result
        }
        
        return .black
    }
}
