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
import UIKit

/// For code coverage.
#if canImport(DTBKit_Core)
@_exported import DTBKit_Core
#endif

//MARK: - Class Chain

/// Indicate which one supports "chainable". In order to prevent ambiguity in memory semantics when used by business parties, it is only recommended to use reference types.
///
/// 标明支持通过链式语法来修改属性，并提供了额外的关键字。为了防止业务方使用时在内存语义上出现歧义，只建议引用类型使用。
public protocol Chainable {}

/// Class only.
extension Wrapper where Base: Kitable {
    
    /// Call handler when condition is true. sync.
    ///
    /// 语法糖: 当条件判断为 true 时才会执行 handler.
    ///
    /// Usage example:
    /// ```
    ///    UIView().dtb
    ///        .when(1 > 0) { me in
    ///            let nSize = me.sizeThatFits(UIScreen.main.bounds.size)
    ///            me.bounds = .init(origin: .zero, size: nSize)
    ///        }
    ///        .center(CGPoint(x: 20.0, y: 20.0))
    /// ```
    @inline(__always)
    @discardableResult
    public func when(_ condition: @autoclosure (() -> Bool), _ handler: ((Base) -> Void)?) -> Self {
        if condition() {
            handler?(me)
        }
        return self
    }
    
    /// Call handler when provider is not nil. sync.
    ///
    /// 语法糖: 当 provider() != nil 时才会执行 handler.
    ///
    /// e.g.
    /// ```
    ///     public func decimal(
    ///         _ value: Int = 2,
    ///         prefix: String? = nil,
    ///     ) -> NumberFormatter {
    ///         return NumberFormatter().dtb
    ///             .decimal(value)
    ///             .whenNotNull(prefix, { data, me in
    ///                 me.dtb.prefix(data)
    ///             })
    ///             .value
    ///     }
    /// ```
//    @discardableResult
//    func whenNotNull<D>(_ provider: @autoclosure (() -> D?), _ handler: ((D, Base) -> Void)?) -> Self {
//        if let data = provider() {
//            handler?(data, me)
//        }
//        return self
//    }
}

// MARK: - Struct Chain

/// Indicate which one supports "chainable". The chain syntax of value types can be implemented to a certain extent, but this conflicts with the basic semantics of copy during assignment, so it is currently limited to use in rapid creation.
///
/// 标明支持通过链式语法来修改属性，并提供了额外的关键字。值类型的链式语法可以在一定程度上实现，但这样和赋值时 copy 的基本语义冲突，所以目前限制在快速创建时使用。
public protocol StructChainable: Chainable {
    
    /// [PRIVATE] Provide default init object for ``StaticWrapper``. Do not use.
    ///
    /// 向类方法提供默认创建的对象。不要外部使用。
    static func def_() -> Self
}

/// Struct only.
extension StaticWrapper where T: Structable & StructChainable {
    
    /// Allows chaining syntax to quickly create objects. Note: Unless you understand the characteristics of value types, it is not recommended to use intermediate variables in procedures. Please refer to ``DemoEntry.swift`` for details.
    ///
    /// 允许用链式语法来快速创建对象。注意：除非你理解值类型的特性，否则过程中不建议使用中间变量。具体请参照 ``DemoEntry.swift``。
    ///
    /// Usage example:
    /// ```
    ///    let dict: [NSAttributedString.Key: Any] = .dtb.create
    ///        .foregroundColor(UIColor.black)
    ///        .font(UIFont.systemFont(ofSize: 13.0))
    ///        .value
    ///
    ///    var a = CGSize.dtb.create.height(2).width(1).value
    /// ```
    @inline(__always)
    public var create: MutableWrapper<T> {
        return MutableWrapper(T.def_())
    }
}

/// Support struct "chainable". In order to prevent ambiguity in memory semantics when used by business parties, currently only static methods are allowed to be used for quick creation.
///
/// 可变值类型容器。为了防止业务方使用时在内存语义上出现歧义，目前只允许用静态方法快速创建对象时使用。
public class MutableWrapper<Base> {
    public var me: Base
    public init(_ value: Base) { self.me = value }
}

/// Struct chain syntax.
///
/// 额外关键字。
extension MutableWrapper where Base: Structable & Chainable {
    
    /// Default unbox, use it to get actual value.
    ///
    /// 默认拆箱关键字。
    @inline(__always)
    public var value: Base { return me }
}

