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

public protocol StringProvider {
    
    func create(_ param: Any?) -> String?
}

extension StaticWrapper where T == String {
    
    /// Create string by provider.
    ///
    /// 字符串 调用收束
    public func create(_ param: Any?) -> String? {
        return DTB.app.get(DTB.BasicInterface.stringKey)?.create(param) ?? (param as? String)
    }
}
