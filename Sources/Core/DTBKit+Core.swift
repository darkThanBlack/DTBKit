//
//  DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2023/6/28
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation
import CoreGraphics

//MARK: - Sub namespace

extension DTB {
    
    /// Definition for NSNotification.Name.
    public enum Notifications {}
    
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

//MARK: - Candy

extension DTB {
    
    /// Memory dict / App data / etc.
    public static let app = AppManager.shared
    
    /// LLDB Console, replacement for ``Swift.print``
    public static let console = ConsoleManager.shared
    
    /// Try adjust from 'Any'
    public static let `any` = AnyConvert()
}

//MARK: - DTB.Kitable

///
extension NSObject: DTB.Kitable {}

// MARK: - DTB.Structable

extension Int: DTB.Structable {}

extension Int8: DTB.Structable {}

extension Int16: DTB.Structable {}

extension Int32: DTB.Structable {}

extension Int64: DTB.Structable {}

extension Float: DTB.Structable {}

extension Double: DTB.Structable {}

extension String: DTB.Structable {}

extension CGFloat: DTB.Structable {}

extension Decimal: DTB.Structable {}

extension Array: DTB.Structable {}

extension Data: DTB.Structable {}
