//
//  DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

// MARK: Special thanks to ``KingFisher``!

import Foundation

//MARK: - static name space

public enum DTB {}

//MARK: - protocol name space

public struct DTBKitWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DTBKitable: AnyObject {}

extension DTBKitable {
    ///
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
}

public protocol DTBKitableValue {}

extension DTBKitableValue {
    ///
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
}

// MARK: -

extension UIColor: DTBKitable {}

extension Int64: DTBKitableValue {}
