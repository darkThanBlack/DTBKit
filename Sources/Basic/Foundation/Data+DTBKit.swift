//
//  Data+DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2024/10/22
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Json
public extension DTBKitWrapper where Base == Data {
    
    /// Encoding to ``String``
    func string(_ encoding: String.Encoding = .utf8) -> DTBKitWrapper<String>? {
        return String(data: me, encoding: encoding)?.dtb
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    func json<T>() -> T? {
        return (try? JSONSerialization.jsonObject(with: me, options: JSONSerialization.ReadingOptions.allowFragments)) as? T
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
