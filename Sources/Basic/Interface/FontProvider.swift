//
//  FontProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/10/9
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
public protocol FontProvider {
    
    func create(_ param: Any?) -> UIFont
}

extension StaticWrapper where T: UIFont {
    
    /// Create font with provider.
    ///
    /// 字体调用收束
    @inline(__always)
    public func create(_ param: Any?) -> UIFont {
        return DTB.app.get(DTB.BasicInterface.fontKey)?.create(param) ?? UIFont.systemFont(ofSize: 17.0)
    }
    
    /// Create font with provider.
    ///
    /// 字体调用收束
    @inline(__always)
    public func create(_ name: String? = nil, size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return DTB.app.get(DTB.BasicInterface.fontKey)?.create(
            [
                "name": name ?? "",
                "size": size,
                "weight": weight
            ]
        ) ?? UIFont.systemFont(ofSize: 17.0)
    }
}
