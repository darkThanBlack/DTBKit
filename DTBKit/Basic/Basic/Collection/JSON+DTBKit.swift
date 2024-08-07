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

///
public extension DTBKitWrapper {
    
    /// System json parser.
    ///
    /// 纯原生解析
    func jsonString() -> String? where Base: Collection {
        guard JSONSerialization.isValidJSONObject(me) else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

///
public extension DTBKitWrapper where Base == String {
    
    /// System json parser.
    ///
    /// 纯原生解析
    func json<T>() -> T? {
        guard let data = me.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return  nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)) as? T
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    func jsonDict() -> [String: Any]? {
        return json()
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    func jsonArray() -> [Any]? {
        return json()
    }
}
