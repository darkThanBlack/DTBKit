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
import UIKit

//MARK: - protocol name space

public struct DTBKitWrapper<Base> {
    public let me: Base
    public init(_ base: Base) {
        self.me = base
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

//MARK: - static name space

///
public enum App {}

///
public enum Navigate {}

///
public enum Color {}

// MARK: - Maths

extension CGFloat: DTBKitableValue {}

extension CGSize: DTBKitableValue {}

extension UIImage: DTBKitable {}

extension UIViewController: DTBKitable {}

extension Array: DTBKitableValue {}
