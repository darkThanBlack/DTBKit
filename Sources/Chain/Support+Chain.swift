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

import Foundation
import UIKit

//MARK: - class 只管实现就好了

extension NSObject: Chainable {}

//MARK: - struct 要考虑的事情就多了

extension Dictionary: Structable, StructChainable {
    
    @inline(__always)
    public static func def_() -> Self {
        return [:]
    }
}

extension CGSize: Structable {}

extension CGRect: Structable {}

extension Date: Structable {}

extension NSRange: Structable {}

extension UIEdgeInsets: Structable {}
