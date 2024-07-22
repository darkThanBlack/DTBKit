//
//  Collection+DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2024/7/22
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Foundation

/// JSON 模型转换
public extension Collection {
    
    /// FIXME: protocol /  extension
    func toJSONString() -> String? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [])  else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
