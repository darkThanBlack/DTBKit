//
//  DTBKitString.swift
//  DTBKit
//
//  Created by moonShadow on 2023/12/28
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Foundation

extension DTB.Providers {
    
    public static let stringKey = DTB.ConstKey<any StringProvider>("dtb.providers.string")
    
    public protocol StringProvider {
        
        func create(_ param: Any?) -> String
        
        func create(format key: String, _ args: [String]) -> String
    }
}

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
