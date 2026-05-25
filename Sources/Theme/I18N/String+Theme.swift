//
//  String+Theme.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension StaticWrapper where T == String {
    
    /// Create string by provider.
    ///
    /// 字符串 调用收束
    @inline(__always)
    public func create(_ param: Any?) -> String {
        return DTB.Providers.get(DTB.Providers.stringKey)?.create(param) ?? ""
    }
    
    /// Create string by provider.
    ///
    /// 字符串 调用收束
    @inline(__always)
    public func create(format key: String, _ args: String...) -> String {
        return DTB.Providers.get(DTB.Providers.stringKey)?.create(format: key, args) ?? ""
    }
}
