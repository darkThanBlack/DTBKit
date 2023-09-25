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
    let me: Base
    public init(_ value: Base) { self.me = value }
    
    public var done: Base { return me }
}

//MARK: - Chain

protocol DTBKitChainable {
    associatedtype ChainT
    var me: ChainT { get }
}

extension DTBKitChainable {
    ///
    public var set: DTBKitChainWrapper<ChainT> {
        get { return DTBKitChainWrapper(me) }
        set { }
    }
}

///
public struct DTBKitChainWrapper<Base> {
    let me: Base
    public init(_ value: Base) { self.me = value }
    
    //[DEPRESSED]
    //@dynamicMemberLookup
    //    subscript<T>(dynamicMember keyPath: WritableKeyPath<Base, T>) -> ((T) -> (DTBKitChainWrapper<Base>)) {
    //        var n = me
    //        return { value in
    //            n[keyPath: keyPath] = value
    //            return DTBKitChainWrapper(n)
    //        }
    //    }
}

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

extension UIView: DTBKitable {}

extension DTBKitWrapper: DTBKitChainable where Base: UIView {
    public typealias ChainT = Base
}

