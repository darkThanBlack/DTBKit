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

//MARK: - Kitable

///
extension NSObject: Kitable {}

// MARK: - Structable

extension Int: Structable {}

extension Int8: Structable {}

extension Int16: Structable {}

extension Int32: Structable {}

extension Int64: Structable {}

extension Float: Structable {}

extension Double: Structable {}

extension String: Structable {}

extension CGFloat: Structable {}

extension Decimal: Structable {}

extension Array: Structable {}

extension Data: Structable {}
