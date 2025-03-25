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

// Special thanks: ``KingFisher``

import Foundation

/// Static name space.
///
/// 静态对象命名空间。
public enum DTB {}

//MARK: - Name spaces

/// Indicate which one implements the namespace for ``class``.
///
/// 核心的引用对象协议。
public protocol DTBKitable: AnyObject {}

extension DTBKitable {
    
    /// Namespace for instance method.
    ///
    /// 成员函数。
    ///
    /// Usage example:
    /// ```
    ///     UIView().dtb
    /// ```
    @inline(__always)
    public var dtb: DTBKitWrapper<Self> {
        return DTBKitWrapper(self)
    }
    
    /// Namespace for static method.
    ///
    /// 静态方法。
    ///
    /// Usage example:
    /// ```
    ///     UIView.dtb
    /// ```
    @inline(__always)
    public static var dtb: DTBKitStaticWrapper<Self> {
        return DTBKitStaticWrapper()
    }
}

/// Indicate which one implements the namespace for ``struct``.
///
/// 核心的值对象协议。
public protocol DTBKitStructable {}

extension DTBKitStructable {
    
    /// Namespace for instance method.
    ///
    /// 成员函数。
    ///
    /// Usage example:
    /// ```
    ///     UIView().dtb
    /// ```
    @inline(__always)
    public var dtb: DTBKitWrapper<Self> {
        return DTBKitWrapper(self)
    }
    
    /// Namespace for static method.
    ///
    /// 静态方法。
    ///
    /// Usage example:
    /// ```
    ///     UIView.dtb
    /// ```
    @inline(__always)
    public static var dtb: DTBKitStaticWrapper<Self> {
        return DTBKitStaticWrapper()
    }
}

//MARK: - Wrapper

/// Mainly instance wrapper.
///
/// 对象容器。
@dynamicMemberLookup
public struct DTBKitWrapper<Base> {
    public let me: Base
    public init(_ value: Base) { self.me = value }
    
    /// Default unbox, use it to get actual value.
    ///
    /// 默认拆箱关键字。
    ///
    /// Usage example:
    /// ```
    ///     let label = UILabel().dtb.text("title").value
    /// ```
    @inline(__always)
    public var value: Base { return me }
    
    /// Chainable for any property.
    ///
    /// 链式语法兼容
    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> ((Value) -> DTBKitWrapper<Base>) {
        var subject = self.me
        return { value in
            subject[keyPath: keyPath] = value
            return self
        }
    }
}

/// Mainly static wrapper.
///
/// 静态方法容器。
public struct DTBKitStaticWrapper<T> {
    public init() {}
}

//MARK: - Implementation

///
extension NSObject: DTBKitable {}

/// Mark protocol is abstract.
///
/// 表明某个接口是抽象接口。
public protocol DTBKitAbstract {}
