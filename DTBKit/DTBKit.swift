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

//MARK: - Protocol

/// For ``class``
public protocol DTBKitable: AnyObject {}

/// For ``class``, use "var"
public protocol DTBKitMutable: AnyObject {}

/// For ``class``, use "weak"
public protocol DTBKitWeakable: AnyObject {}

/// For ``struct``
public protocol DTBKitStructable {}

/// For ``struct``, use "inout" / "&"
public protocol DTBKitStructMutable {}

//MARK: - Interface

extension DTBKitable {
    ///
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
}

extension DTBKitMutable {
    ///
    public var dtb: DTBKitMutableWrapper<Self> {
        get { return DTBKitMutableWrapper(self) }
        set { }
    }
}

extension DTBKitWeakable {
    ///
    public var dtb: DTBKitWeakWrapper<Self> {
        get { return DTBKitWeakWrapper(self) }
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

extension DTBKitStructMutable {
    ///
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
}

//MARK: - Wrapper

///
public struct DTBKitWrapper<Base> {
    let me: Base
    public init(_ base: Base) { self.me = base }
    
    public var done: Base { return me }
}

///
public struct DTBKitMutableWrapper<Base> {
    var me: Base
    public init(_ base: Base) { self.me = base }
    
    public var done: Base { return me }
}

///
public struct DTBKitWeakWrapper<Base: AnyObject> {
    weak var me: Base?
    public init(_ base: Base) { self.me = base }
    
    public var done: Base? { return me }
}

///
public struct DTBKitStructMutableWrapper<Base> {
    var me: Base
    public init(_ base: inout Base) { self.me = base }
    
    public var done: Base { return me }
}

//MARK: - Candy

public protocol DTBKitChainCandyable: DTBKitWeakable {}

extension DTBKitWeakWrapper {
    ///
    public var set: Self {
        get { return self }
        set { }
    }
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

extension UIView: DTBKitWeakable, DTBKitChainCandyable {}

//extension UILabel: DTBKitable {}
//
//extension UIImageView: DTBKitable {}
//
//extension UIButton: DTBKitable {}
