//
//  String+i18N.swift
//  DTBKit
//
//  Created by moonShadow on 2025/3/25
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// 国际化: 字符串 抽象接口
public protocol DTBKitString {
    
    associatedtype StringKeyType = String
    
    associatedtype StringExtraParam = AnyObject
    
    /// Text generate | 文本生成收口
    ///
    /// 便于处理 国际化 等需求
    func create(_ key: StringKeyType, _ param: StringExtraParam?) -> String
}

extension DTBKitString where StringKeyType == String {
    
    public func create(_ key: StringKeyType, _ param: StringExtraParam? = nil) -> String {
        return key
    }
}
