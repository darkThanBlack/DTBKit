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
    ///   - key_: 唯一标识
    ///
    ///   - useLock_: 用来区分是否需要加锁
    public struct ConstKey<ValueType> {
        
        public let key_: String
        
        public let useLock_: Bool
        
        /// 默认实现是 ``DTB.app``
        ///
        /// - Parameters:
        ///   - key_: 允许不传，默认用 UUID 代替，方便在局部使用的临时存储；暂时不考虑类型哈希
        ///
        ///   - useLock_: 用来区分是否需要加锁；根据 ``CoreTests`` 内的性能测试，带锁版本性能损耗大约在 10% （10w 级调用 0.01s），可以默认加锁
        public init(_ key: String = UUID().uuidString, useLock: Bool = true) {
            self.key_ = key
            self.useLock_ = useLock
        }
    }
}
