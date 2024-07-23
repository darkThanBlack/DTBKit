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

//MARK: - Class Chain

/// Indicate which one supports "chainable". In order to prevent ambiguity in memory semantics when used by business parties, it is only recommended to use reference types.
///
/// 标明支持通过链式语法来修改属性，并提供了额外的关键字。为了防止业务方使用时在内存语义上出现歧义，只建议引用类型使用。
public protocol DTBKitChainable {}

/// Class only.
extension DTBKitWrapper where Base: DTBKitable {
    
    /// Custom updates, auto unbox, sync.
    ///
    /// 通用的自行拆箱更新，均为同步操作。
    ///
    /// Usage example:
    /// ```
    ///    UIView().dtb
    ///        .when(1 > 0) { value in
    ///            let nSize = value.sizeThatFits(UIScreen.main.bounds.size)
    ///            value.bounds = .init(origin: .zero, size: nSize)
    ///        }
    ///        .center(CGPoint(x: 20.0, y: 20.0))
    /// ```
    @discardableResult
    public func when(_ condition: @autoclosure (() -> Bool), _ handler: ((Base) -> Void)?) -> Self {
        if condition() {
            handler?(me)
        }
        return self
    }
}

// MARK: - Struct Chain

/// Indicate which one supports "chainable". The chain syntax of value types can be implemented to a certain extent, but this conflicts with the basic semantics of copy during assignment, so it is currently limited to use in rapid creation.
///
/// 标明支持通过链式语法来修改属性，并提供了额外的关键字。值类型的链式语法可以在一定程度上实现，但这样和赋值时 copy 的基本语义冲突，所以目前限制在快速创建时使用。
public protocol DTBKitStructChainable: DTBKitChainable {
    
    /// [PRIVATE] Provide default init object for ``DTBKitStaticWrapper``. Do not use.
    ///
    /// 向类方法提供默认创建的对象。不要外部使用。
    static func def_() -> Self
}

/// Struct only.
extension DTBKitStaticWrapper where T: DTBKitStructable & DTBKitStructChainable {
    
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
    public var create: DTBKitMutableWrapper<T> {
        return DTBKitMutableWrapper(T.def_())
    }
}

/// Support struct "chainable". In order to prevent ambiguity in memory semantics when used by business parties, currently only static methods are allowed to be used for quick creation.
///
/// 可变值类型容器。为了防止业务方使用时在内存语义上出现歧义，目前只允许用静态方法快速创建对象时使用。
public class DTBKitMutableWrapper<Base> {
    internal var me: Base
    public init(_ value: Base) { self.me = value }
}

/// Struct chain syntax.
///
/// 额外关键字。
extension DTBKitMutableWrapper where Base: DTBKitStructable & DTBKitChainable {
    
    /// Default unbox, use it to get actual value.
    ///
    /// 默认拆箱关键字。
    public var value: Base { return me }
}

//MARK: - Class 只管实现就好了

extension NSObject: DTBKitChainable {}

//MARK: - Struct 要考虑的事情就多了

extension Dictionary: DTBKitStructable, DTBKitStructChainable {
    public static func def_() -> Self {
        return [:]
    }
}

extension CGSize: DTBKitStructable {}

extension CGRect: DTBKitStructable {}

extension NSRange: DTBKitStructable {}

extension UIEdgeInsets: DTBKitStructable {}
