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
    
    func create(_ param: Any?) -> UIColor
}

extension StaticWrapper where T: UIColor {
    
    /// Create color with provider.
    ///
    /// 颜色调用收束
    @inline(__always)
    public func create(_ param: Any?) -> UIColor {
        return DTB.app.get(DTB.BasicInterface.colorKey)?.create(param) ?? .black
    }
}
