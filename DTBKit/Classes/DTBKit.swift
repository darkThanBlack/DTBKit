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

// MARK: Special thanks to ``KingFisher``!

import Foundation

//MARK: - static name space

public enum DTB {}

extension DTB {
    ///
    public enum App {}
    ///
    public enum Navigate {}
}

//MARK: - protocol name space

public struct DTBKitWrapper<Base> {
    public let mySelf: Base
    public init(_ base: Base) {
        self.mySelf = base
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

extension Int64: DTBKitableValue {}

extension UIViewController: DTBKitable {}

