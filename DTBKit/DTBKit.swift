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

/// Indicate which one implements the namespace for ``class``
///
/// Use the sample code to convert it to a special name for your own project:
/// ```
/// extension DTBKitable {
///    public var your_proj_prefix: DTBKitWrapper<Self> { return dtb }
/// }
/// ```
public protocol DTBKitable: AnyObject {}

/// Indicate which one implements the namespace for ``struct``
///
/// Use the sample code to convert it to a special name for your own project:
/// ```
/// extension DTBKitStructable {
///    public var your_proj_prefix: DTBKitWrapper<Self> { return dtb }
/// }
/// ```
public protocol DTBKitStructable {}

extension DTBKitable {
    
    /// Namespace for instance method, e.g. ``UIView().dtb``
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
    
    /// Namespace for static method, e.g. ``UIView.dtb``
    static public var dtb: DTBKitStaticWrapper<Self> {
        get { return DTBKitStaticWrapper() }
        set { }
    }
}

extension DTBKitStructable {
    
    /// Namespace for instance method, e.g. ``UIView().dtb``
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
    
    /// Namespace for static method, e.g. ``UIView.dtb``
    static public var dtb: DTBKitStaticWrapper<Self> {
        get { return DTBKitStaticWrapper() }
        set { }
    }
}

///
public struct DTBKitWrapper<Base> {
    internal let me: Base
    public init(_ value: Base) { self.me = value }
    
    /// Default unbox
    ///
    /// For example:
    /// ```
    ///     let label = UILabel().dtb.text("title").value
    /// ```
    public var value: Base { return me }
}

///
public struct DTBKitStaticWrapper<T> {
    
    internal var serials: [(() -> Bool)] = []
}

//MARK: - Chain

/// Indicate which one supports "Chainable"
public protocol DTBKitChainable {}

/// Chain syntax candy
extension DTBKitWrapper where Base: DTBKitChainable {
    
    /// Same as ``.value``
    public var `get`: Base { return me }
    
    /// Same as ``.dtb``
    public var `set`: Self { return self }
    
    /// Custom update action
    ///
    /// For example:
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

//MARK: - Promise

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

//MARK: - Defines

extension Double: DTBKitStructable {}

extension CGFloat: DTBKitStructable {}

extension CGSize: DTBKitStructable {}

extension CGRect: DTBKitStructable {}

extension Array: DTBKitStructable {}

extension UIColor: DTBKitable {}

extension UIImage: DTBKitable {}

extension UIView: DTBKitable, DTBKitChainable {}

