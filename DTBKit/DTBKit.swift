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

//MARK: - Name space

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
}

extension DTBKitStructable {
    ///
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
}

///
public struct DTBKitWrapper<Base> {
    internal let me: Base
    public init(_ value: Base) { self.me = value }
    
    public var unbox: Base { return me }
}

//MARK: - Chain

public protocol DTBKitChainable {}

/// Chain operators
extension DTBKitWrapper where Base: DTBKitChainable {
    
    @discardableResult
    func update(_ setter: ((Base) -> (Void))) -> Self {
        setter(me)
        return self
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

//MARK: - Static funcs

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

