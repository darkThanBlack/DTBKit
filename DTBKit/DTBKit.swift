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
import UIKit

//MARK: - Name spaces

/// Static name space.
///
/// 静态常量。
public enum DTB {}

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
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
    
    /// Namespace for static method.
    ///
    /// 静态方法。
    ///
    /// Usage example:
    /// ```
    ///     UIView.dtb
    /// ```
    public static var dtb: DTBKitStaticWrapper<Self> {
        get { return DTBKitStaticWrapper() }
        set { }
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
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
    
    /// Namespace for static method.
    ///
    /// 静态方法。
    ///
    /// Usage example:
    /// ```
    ///     UIView.dtb
    /// ```
    public static var dtb: DTBKitStaticWrapper<Self> {
        get { return DTBKitStaticWrapper() }
        set { }
    }
}

//MARK: - Wrapper

/// Mainly instance wrapper.
///
/// 对象容器。
public struct DTBKitWrapper<Base> {
    internal let me: Base
    public init(_ value: Base) { self.me = value }
    
    /// Default unbox, use it to get actual value.
    ///
    /// 默认拆箱关键字。
    ///
    /// Usage example:
    /// ```
    ///     let label = UILabel().dtb.text("title").value
    /// ```
    public var value: Base { return me }
    
    /// [UNSTABLE]
    internal func filter(_ handler: ((Self) -> Bool)) -> Self? {
        return handler(self) ? self : nil
    }
}

/// Mainly static wrapper.
///
/// 静态方法容器。
public struct DTBKitStaticWrapper<T> {
    
    /// [UNSTABLE]
    internal var serials: [(() -> Bool)] = []
}

/// Support struct "chainable". In order to prevent ambiguity in memory semantics when used by business parties, currently only static methods are allowed to be used for quick creation.
///
/// 可变值类型容器。为了防止业务方使用时在内存语义上出现歧义，目前只允许用静态方法快速创建对象时使用。
public class DTBKitMutableWrapper<Base> {
    internal var me: Base
    public init(_ value: Base) { self.me = value }
}

//MARK: - Chain

/// Indicate which one supports "chainable". In order to prevent ambiguity in memory semantics when used by business parties, it is only recommended to use reference types.
///
/// 标明支持通过链式语法来修改属性，并提供了额外的关键字。为了防止业务方使用时在内存语义上出现歧义，只建议引用类型使用。
public protocol DTBKitChainable {}

/// Class only.
extension DTBKitWrapper where Base: DTBKitable & DTBKitChainable {
    
    /// Custom updates, auto unbox.
    ///
    /// 通用的自行拆箱更新。
    ///
    /// Usage example:
    /// ```
    ///    UIView().dtb
    ///        .update { value in
    ///            let nSize = value.sizeThatFits(UIScreen.main.bounds.size)
    ///            value.bounds = .init(origin: .zero, size: nSize)
    ///        }
    ///        .center(CGPoint(x: 20.0, y: 20.0))
    /// ```
    @discardableResult
    public func update(_ setter: ((Base) -> Void)) -> Self {
        setter(me)
        return self
    }
}

/// Indicate which one supports "chainable". The chain syntax of value types can be implemented to a certain extent, but this conflicts with the basic semantics of copy during assignment, so it is currently limited to use in rapid creation.
///
/// 标明支持通过链式语法来修改属性，并提供了额外的关键字。值类型的链式语法可以在一定程度上实现，但这样和赋值时 copy 的基本语义冲突，所以目前限制在快速创建时使用。
public protocol DTBKitStructChainable: DTBKitChainable {
    
    /// [PRIVATE] Provide default init object for ``DTBKitStaticWrapper``. Do not use.
    ///
    /// 向类方法提供默认创建的对象。不要外部使用。
    static func dtb_def_() -> Self
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
    ///    var a = CGSize.dtb.create.width(1).height(2).value
    /// ```
    public var create: DTBKitMutableWrapper<T> {
        return DTBKitMutableWrapper(T.dtb_def_())
    }
}

/// Struct chain syntax.
///
/// 额外关键字。
extension DTBKitMutableWrapper where Base: DTBKitStructable & DTBKitChainable {
    
    /// [UNSTABLE] Convert back to mainly wrapper to use other methods.
    ///
    /// 转换为通用扩展以便使用其他能力。
    internal var then: DTBKitWrapper<Base> { return me.dtb }
    
    /// Default unbox, use it to get actual value.
    ///
    /// 默认拆箱关键字。
    public var value: Base { return me }
}

//MARK: - Declare

extension Int: DTBKitStructable {}

extension Int8: DTBKitStructable {}

extension Int16: DTBKitStructable {}

extension Int32: DTBKitStructable {}

extension Int64: DTBKitStructable {}

extension Float: DTBKitStructable {}

extension Double: DTBKitStructable {}

extension NSNumber: DTBKitable {}

extension NumberFormatter: DTBKitable, DTBKitChainable {}

extension Decimal: DTBKitStructable {}

//MARK: -

extension String: DTBKitStructable {}

extension CGSize: DTBKitStructable, DTBKitStructChainable {
    public static func dtb_def_() -> CGSize {
        return .zero
    }
}

extension CGRect: DTBKitStructable {}

//MARK: -

extension Array: DTBKitStructable {}

extension Dictionary: DTBKitStructable, DTBKitStructChainable {
    public static func dtb_def_() -> Dictionary {
        return [:]
    }
}

//MARK: -

extension NSString: DTBKitable {}

extension NSMutableAttributedString: DTBKitable, DTBKitChainable {}

extension NSRange: DTBKitStructable, DTBKitStructChainable {
    public static func dtb_def_() -> NSRange {
        return NSRange(location: 0, length: 0)
    }
}

extension UIColor: DTBKitable {}

extension CIImage: DTBKitable {}

extension CGImage: DTBKitable {}

extension UIImage: DTBKitable {}

extension UIView: DTBKitable, DTBKitChainable {}

extension UIViewController: DTBKitable {}

@available(iOS 13.0, *)
extension UIWindowScene: DTBKitable {}

//MARK: - UNSTABLE

extension DTBKitStaticWrapper where T: DTBKitChainable {
    
    /// [UNSTABLE]
    mutating func then(_ task: @escaping (() -> Void)) -> Self {
        self.serials.append({
            let _ = task()
            return true
        })
        return self
    }
    
    /// [UNSTABLE]
    mutating func done(_ completed: (() -> Void)? = nil) {
        self.serials.append({
            completed?()
            return true
        })
        fire()
    }
    
    /// [UNSTABLE]
    mutating func fire() {
        guard serials.count > 0 else {
            return
        }
        if let _ = self.serials.first?() {
            serials.removeFirst()
        }
        fire()
    }
}
