//
//  ConstKey.swift
//  DTBKit
//
//  Created by moonShadow on 2025/3/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// 用于声明带类型推断的静态常量
    ///
    /// Represents a `Key` with an associated generic value type. More details in ``Explain.md``.
    ///
    /// Special thanks: [DefaultsKit](https://github.com/nmdias/DefaultsKit)
    ///
    /// Example:
    /// ```
    ///     let key = DTB.ConstKey<[String: Any]>("myUserDefaultsKey")
    /// ```
    ///
    /// - Parameters:
    ///   - key: 如果不传，使用 UUID 作为 key，暂时不考虑类型哈希
    ///
    ///   - baseOn: 如果在非主线程使用 DTB.app 时，useLock 传 true，内部会加锁
    public struct ConstKey<ValueType> {
        
        let key_: String
        
        let useLock_: Bool
        
        public init(_ key: String = UUID().uuidString, useLock: Bool = false) {
            self.key_ = key
            self.useLock_ = useLock
        }
    }
}
