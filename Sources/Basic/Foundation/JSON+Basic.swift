//
//  JSON+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/11
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
public extension Wrapper where Base: Collection {
    
    /// 纯原生解析 | System json parser
    func jsonString() -> Wrapper<String>? where Base: Collection {
        guard me.isEmpty == false, JSONSerialization.isValidJSONObject(me) else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: me, options: [.fragmentsAllowed]) else {
            return nil
        }
        return String(data: data, encoding: .utf8)?.dtb
    }
    
    ///
    func json<T: Codable>() -> T? where Base: Collection {
        guard JSONSerialization.isValidJSONObject(me) else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: me, options: [.fragmentsAllowed]) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

///
public extension Wrapper where Base == String {
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func json<T>() -> T? {
        guard let data = me.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)) as? T
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func jsonDict() -> [String: Any]? {
        return json()
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func jsonArray() -> [Any]? {
        return json()
    }
}

public extension Wrapper where Base == Data {
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func json<T>() -> T? {
        return (try? JSONSerialization.jsonObject(with: me, options: .allowFragments)) as? T
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func jsonDict() -> [String: Any]? {
        return json()
    }
    
    /// System json parser.
    ///
    /// 纯原生解析
    @inline(__always)
    func jsonArray() -> [Any]? {
        return json()
    }
}
