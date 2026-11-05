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
public protocol Kitable: AnyObject {}

extension Kitable {
    
    /// Namespace for instance method.
    ///
    /// 成员函数。
    ///
    /// Usage example:
    /// ```
    ///     UIView().dtb
    /// ```
    @inline(__always)
    public var dtb: Wrapper<Self> {
        return Wrapper(self)
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
    public static var dtb: StaticWrapper<Self> {
        return StaticWrapper()
    }
}

/// Indicate which one implements the namespace for ``struct``.
///
/// 核心的值对象协议。
public protocol Structable {}

extension Structable {
    
    /// Namespace for instance method.
    ///
    /// 成员函数。
    ///
    /// Usage example:
    /// ```
    ///     UIView().dtb
    /// ```
    @inline(__always)
    public var dtb: Wrapper<Self> {
        return Wrapper(self)
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
    public static var dtb: StaticWrapper<Self> {
        return StaticWrapper()
    }
}

//MARK: - Wrapper

/// Mainly instance wrapper.
///
/// 对象容器。
@dynamicMemberLookup
public struct Wrapper<Base> {
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
}

/// Chainable for any property.
///
/// 链式语法兼容。
///
/// - Important: 只对引用类型开放。值类型的 `me` 是副本，写入不会回传到 `value`，
///   所以这里用 `Base: AnyObject` 把它挡在编译期（而不是运行时静默 no-op）。
///   值类型请使用 `MutableWrapper` 或各自的构造器。
extension Wrapper where Base: AnyObject {
    
    public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Base, Value>) -> ((Value) -> Wrapper<Base>) {
        var subject = me
        return { value in
            subject[keyPath: keyPath] = value
            return self
        }
    }
}

/// Mainly static wrapper.
///
/// 静态方法容器。
public struct StaticWrapper<T> {
    public init() {}
}

