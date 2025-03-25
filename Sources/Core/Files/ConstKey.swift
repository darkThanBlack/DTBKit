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
    
    /// 用于声明带类型推断的静态常量。
    ///
    /// Represents a `Key` with an associated generic value type. More details in ``dtbkit_explain.md``.
    ///
    /// Special thanks: [DefaultsKit](https://github.com/nmdias/DefaultsKit)
    ///
    /// Example:
    /// ```
    ///     let key = DTB.ConstKey<[String: Any]>("myUserDefaultsKey")
    /// ```
    public struct ConstKey<ValueType> {
        
        public let key_: String
        
        public init(_ key: String) {
            self.key_ = key
        }
    }
}
