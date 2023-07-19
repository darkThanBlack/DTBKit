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

//MARK: - Namespaces

///
public struct DTBKitWrapper<Base> {
    public let me: Base
    public init(_ base: Base) {
        self.me = base
    }
}

/// namespace for class
public protocol DTBKitable: AnyObject {}

extension DTBKitable {
    ///
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
}

/// namespace for struct
public protocol DTBKitableValue {}

extension DTBKitableValue {
    ///
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
}

//MARK: - Static funcs

///
public enum App {}

///
public enum Navigate {}

///
public enum Color {}

// MARK: - Submodule: Basic

extension CGFloat: DTBKitableValue {}

extension CGSize: DTBKitableValue {}

extension UIImage: DTBKitable {}

extension UIImageView: DTBKitable {}

extension UIViewController: DTBKitable {}

extension Array: DTBKitableValue {}
