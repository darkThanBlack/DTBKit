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
/// Use the sample code to convert it to a special name for your own project:
/// ```
/// extension DTBKitable {
///    public var your_proj_prefix: DTBKitWrapper<Self> { return dtb }
/// }
/// ```
public protocol DTBKitable: AnyObject {}

extension DTBKitable {
    
    /// Namespace for instance method, e.g. ``UIView().dtb``
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
    
    /// Namespace for static method, e.g. ``UIView.dtb``
    public static var dtb: DTBKitStaticWrapper<Self> {
        get { return DTBKitStaticWrapper() }
        set { }
    }
}

/// Indicate which one implements the namespace for ``struct``.
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
    /// Usage example: ``UIView().dtb``
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
    
    /// Namespace for static method.
    ///
    /// Usage example: ``UIView.dtb``
    public static var dtb: DTBKitStaticWrapper<Self> {
        get { return DTBKitStaticWrapper() }
        set { }
    }
}

//MARK: - Wrapper

/// Mainly instance wrapper.
public struct DTBKitWrapper<Base> {
    internal let me: Base
    public init(_ value: Base) { self.me = value }
    
    /// Default unbox, use it to get actual value.
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
public struct DTBKitStaticWrapper<T> {
    
    /// [UNSTABLE]
    internal var serials: [(() -> Bool)] = []
}

/// In order to support struct "chainable".
public class DTBKitMutableWrapper<Base> {
    internal var me: Base
    public init(_ value: Base) { self.me = value }
}

//MARK: - Chain

/// Indicate which one supports "chainable".
public protocol DTBKitChainable {}

/// Class only.
extension DTBKitWrapper where Base: DTBKitable & DTBKitChainable {
    
    /// Custom updates, auto unbox.
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
    /// Usage example:
    /// ```
    ///     var result = CGSize().dtb.set.width(1.0).value
    ///     result.dtb.set.height(2.0)
    /// ```
    public var `set`: DTBKitMutableWrapper<Base> {
        get { return DTBKitMutableWrapper(me) }
        set { }
    }
}

/// Syntax.
extension DTBKitMutableWrapper where Base: DTBKitStructable & DTBKitChainable {
    
    /// Convert back to mainly wrapper to use other methods.
    public var then: DTBKitWrapper<Base> { return me.dtb }
    
    /// Unbox.
    public var value: Base { return me }
}

//MARK: - UNSTABLE: promise like

extension DTBKitStaticWrapper where T: DTBKitChainable {
    
    /// [UNSTABLE]
    public mutating func then(_ task: @escaping (() -> Void)) -> Self {
        self.serials.append({
            let _ = task()
            return true
        })
        return self
    }
    
    /// [UNSTABLE]
    public mutating func done(_ completed: (() -> Void)? = nil) {
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

extension NSRange: DTBKitStructable {}

extension UIColor: DTBKitable {}

extension UIImage: DTBKitable {}

extension UIView: DTBKitable, DTBKitChainable {}

extension UIViewController: DTBKitable {}
