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

//MARK: - Prefix

/// For ``class``
public protocol DTBKitable: AnyObject {}

/// For ``struct``
public protocol DTBKitStructable {}

extension DTBKitable {
    ///
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
    
    static public var dtb: DTBkitStaticWrapper<Self> {
        get { return DTBkitStaticWrapper() }
        set { }
    }
}

extension DTBKitStructable {
    ///
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
    
    static public var dtb: DTBkitStaticWrapper<Self> {
        get { return DTBkitStaticWrapper() }
        set { }
    }
}

///
public struct DTBKitWrapper<Base> {
    internal let me: Base
    public init(_ value: Base) { self.me = value }
    
    public var value: Base { return me }
}

///
public struct DTBkitStaticWrapper<T> {
    
    internal var serials: [(() -> Bool)] = []
}

//MARK: - Chain

///
public protocol DTBKitChainable {}

extension DTBKitWrapper where Base: DTBKitChainable {
    
    public var get: Base { return me }
    
    @discardableResult
    public func update(_ setter: ((Base) -> Void)) -> Self {
        setter(me)
        return self
    }
}

extension DTBkitStaticWrapper where T: DTBKitChainable {
    
    public mutating func then(_ task: @escaping (() -> Void)) -> Self {
        self.serials.append({
            let _ = task()
            return true
        })
        return self
    }
    
    public mutating func done(_ completed: (() -> Void)? = nil) {
        self.serials.append({
            completed?()
            return true
        })
        fire()
    }
    
    public mutating func fire() {
        guard serials.count > 0 else {
            serials.removeAll()
            return
        }
        if let _ = self.serials.first?() {
            serials.removeFirst()
        }
        fire()
    }
}

// [FUTURE]

// [Style1] any protocol
//    public func set() -> Self where Self: DTBKitChainable { return self }

// [Style2] another wrapper
//public protocol DTBKitChainable {
//    associatedtype ChainT
//    var obj: ChainT { get }
//}
//
//extension DTBKitChainable {
//    ///
//    public var set: DTBKitChainWrapper<ChainT> {
//        get { return DTBKitChainWrapper(obj) }
//        set { }
//    }
//}
//
/////
//public struct DTBKitChainWrapper<Base> {
//    internal let me: Base
//    public init(_ value: Base) { self.me = value }
//}
//
///// Syntax candy
//extension DTBKitChainWrapper {
//    public var then: DTBKitWrapper<Base> { return DTBKitWrapper(me) }
//    public var unBox: Base { return me }
//    public func done() {}
//}

// [DEPRESSED]

// [Style3] key-path
// 1: always hint get only property
// 2: confilct with ``Chainable``
//@dynamicMemberLookup
//    subscript<T>(dynamicMember keyPath: WritableKeyPath<Base, T>) -> ((T) -> (DTBKitChainWrapper<Base>)) {
//        var n = me
//        return { value in
//            n[keyPath: keyPath] = value
//            return DTBKitChainWrapper(n)
//        }
//    }

//MARK: - Static

///
public enum DTB {}

///
public enum Color {}


//MARK: - Defines

extension Double: DTBKitStructable {}

extension CGFloat: DTBKitStructable {}

extension CGSize: DTBKitStructable {}

extension CGRect: DTBKitStructable {}

extension Array: DTBKitStructable {}

extension UIImage: DTBKitable {}

extension UIView: DTBKitable, DTBKitChainable {}

//extension DTBKitWrapper: DTBKitChainable where Base: UIView {
//    public typealias ChainT = Base
//}

