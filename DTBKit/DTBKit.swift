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

//MARK: -

/// Wrapper
public struct DTBKitWrapper<Base> {
    /// Same as ``self``
    public let me: Base
    public init(_ base: Base) {
        self.me = base
    }
}

/// For ``class``
public protocol DTBKitable: AnyObject {}

extension DTBKitable {
    ///
    public var dtb: DTBKitWrapper<Self> {
        get { return DTBKitWrapper(self) }
        set { }
    }
}

/// For ``struct``
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
public enum DTB {}

///
public enum Color {}

// MARK: - DTBKit/Basic

extension CGFloat: DTBKitableValue {}

extension CGSize: DTBKitableValue {}

extension CGRect: DTBKitableValue {}

extension Array: DTBKitableValue {}

extension UIViewController: DTBKitable {}

extension UIImage: DTBKitable {}

extension UIImageView: DTBKitable {}

extension UIButton: DTBKitable {}
