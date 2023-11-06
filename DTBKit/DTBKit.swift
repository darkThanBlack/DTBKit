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

/// Indicate which one implements the namespace for ``class``.
///
/// 核心的引用对象协议。
///
/// Use the sample code to convert it to a special name for your own project:
/// ```
/// extension DTBKitable {
///    public var your_proj_prefix: DTBKitWrapper<Self> { return dtb }
/// }
/// ```
public protocol DTBKitable: AnyObject {}

extension DTBKitable {
    
    /// Namespace for instance method.
    ///
    /// 隔离成员函数。
    ///
    /// Usage: ``UIView().dtb``
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
    
    /// Namespace for static method.
    ///
    /// 隔离静态方法。
    ///
    ///  Usage: ``UIView.dtb``
    public static var dtb: DTBKitStaticWrapper<Self> {
        get { return DTBKitStaticWrapper() }
        set { }
    }
}

/// Indicate which one implements the namespace for ``struct``.
///
/// 核心的值对象协议。
///
/// Use the sample code to convert it to a special name for your own project:
/// ```
/// extension DTBKitStructable {
///    public var your_proj_prefix: DTBKitWrapper<Self> { return dtb }
/// }
/// ```
public protocol DTBKitStructable {}

extension DTBKitStructable {
    
    /// Namespace for instance method.
    ///
    /// 隔离成员函数。
    ///
    /// Usage: ``UIView().dtb``
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
    
    /// Namespace for static method.
    ///
    /// 隔离静态方法。
    ///
    /// Usage: ``UIView.dtb``
    public static var dtb: DTBKitStaticWrapper<Self> {
        get { return DTBKitStaticWrapper() }
        set { }
    }
}

//MARK: - Wrapper

/// Mainly instance wrapper.
///
/// 对象类型容器。
public struct DTBKitWrapper<Base> {
    internal let me: Base
    public init(_ value: Base) { self.me = value }
    
    /// Default unbox, use it to get actual value.
    ///
    /// 默认关键字，拆箱。
    ///
    /// Usage example:
    /// ```
    ///     let label = UILabel().dtb.text("title").value
    /// ```
    public var value: Base { return me }
    
    internal func check(_ handler: (() -> Bool)) -> Self? {
        return handler() ? self : nil
    }
}

/// Mainly static wrapper.
///
/// 静态方法容器。
public struct DTBKitStaticWrapper<T> {
    
    /// [UNSTABLE] 施工中
    internal var serials: [(() -> Bool)] = []
}

/// In order to support struct "chainable".
///
/// 因为值类型无法直接修改，专门提供一个容器。
public class DTBKitMutableWrapper<Base> {
    internal var me: Base
    public init(_ value: Base) { self.me = value }
}

//MARK: - Chain

/// Indicate which one supports "chainable".
///
/// 标明哪些对象支持通过链式语法来修改属性，并提供了额外的关键字。
///
/// 注意引用类型和值类型完全不同。
public protocol DTBKitChainable {}

/// Class only.
extension DTBKitWrapper where Base: DTBKitable & DTBKitChainable {
    
    /// Custom updates, auto unbox.
    ///
    /// 任意的引用类型都可以通过此方法自行拆箱更新。
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

/// Struct only.
extension DTBKitWrapper where Base: DTBKitStructable & DTBKitChainable {
    
    /// Simply wrap object to class value.
    ///
    /// Since no object is explicitly held at creation time, "mutating" does not suffice.
    ///
    /// 要想达到类似于修改值类型属性的效果，需要先用该关键字进行一次转换，``mutating`` 和 ``keyPath`` 等系统特性都有各自的不便之处。
    /// 并且一定要注意使用时每个对象的内存地址也是不同的。
    ///
    /// Usage example:
    /// ```
    ///     var result = CGSize().dtb.set.width(1.0).value
    ///     result.dtb.set.height(2.0)
    ///
    ///    let a = [:]
    ///    let b = a.dtb.set.foregroundColor(.white).value
    ///    let c = b.dtb.set.font(.systemFont(ofSize: 15.0)).value
    ///    b.dtb.set.foregroundColor(.black)
    ///
    ///    print("a != b != c")
    ///    print("a, b, c 内存地址不同！")
    /// ```
    public var `set`: DTBKitMutableWrapper<Base> {
        get { return DTBKitMutableWrapper(me) }
        set { }
    }
}

/// Struct chain syntax.
extension DTBKitMutableWrapper where Base: DTBKitStructable & DTBKitChainable {
    
    /// Convert back to mainly wrapper to use other methods.
    public var then: DTBKitWrapper<Base> { return me.dtb }
    
    /// Unbox.
    public var value: Base { return me }
}

//MARK: - UNSTABLE: 施工中

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

//MARK: - Static

///
public enum DTB {}

//MARK: -

extension Int: DTBKitStructable {}

extension Int8: DTBKitStructable {}

extension Int16: DTBKitStructable {}

extension Int32: DTBKitStructable {}

extension Int64: DTBKitStructable {}

extension Float: DTBKitStructable {}

extension Double: DTBKitStructable {}

extension NSNumber: DTBKitable {}

extension NumberFormatter: DTBKitable, DTBKitChainable {}

//MARK: -

extension String: DTBKitStructable {}

extension CGSize: DTBKitStructable, DTBKitChainable {}

extension CGRect: DTBKitStructable {}

//MARK: -

extension Array: DTBKitStructable {}

extension Dictionary: DTBKitStructable, DTBKitChainable {}

//MARK: -

extension NSString: DTBKitable {}

extension NSMutableAttributedString: DTBKitable, DTBKitChainable {}

extension NSRange: DTBKitStructable, DTBKitChainable {}

extension UIColor: DTBKitable {}

extension CIImage: DTBKitable {}

extension CGImage: DTBKitable {}

extension UIImage: DTBKitable {}

extension UIView: DTBKitable, DTBKitChainable {}

extension UIViewController: DTBKitable {}

@available(iOS 13.0, *)
extension UIWindowScene: DTBKitable {}
