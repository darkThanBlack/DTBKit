//
//  Array+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/12
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Foundation

extension Wrapper {
    
    /// Safe array | 数组防越界
    ///
    /// * Sample: ``list[0] => list.dtb[0]``
    /// ``~=``: ``Swift/Collection/Range`` | ``Swift/Misc``,  [refer](https://github.com/swiftlang/swift/blob/ed38b93469c980cbe6d5459798cb8ad8d43bd9a8/stdlib/public/core/StringComparable.swift#L86)
    public subscript<T>(_ index: Int?) -> T? where Base == Array<T> {
        guard let idx = index else {
            return nil
        }
        guard me.startIndex..<me.endIndex ~= idx else {
            return nil
        }
        return me[idx]
    }
}

///
public extension Wrapper where Base: Collection {
    
    /// 纯原生解析 | System json parser
    func jsonString() -> String? where Base: Collection {
        guard JSONSerialization.isValidJSONObject(me) else {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.fragmentsAllowed]) else { return nil }
        return String(data: data, encoding: .utf8)
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
