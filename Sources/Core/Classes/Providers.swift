//
//  Providers.swift
//  DTBKit
//
//  Created by moonShadow on 2025/7/23
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// Some features that require users to fully customize.
    ///
    /// 某些需要让开发者可以完全自定义的功能.
    public enum Providers {
        
        @inline(__always)
        public static func register<T>(_ value: T?, key: DTB.ConstKey<T>) {
            DTB.app.set(value, key: key)
        }
        
        @inline(__always)
        public static func unregister<T>(_ key: DTB.ConstKey<T>) {
            DTB.app.set(nil, key: key)
        }
        
        @inline(__always)
        public static func get<T>(_ key: DTB.ConstKey<T>) -> T? {
            return DTB.app.get(key)
        }
    }
}
