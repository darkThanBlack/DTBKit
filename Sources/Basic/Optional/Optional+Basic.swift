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

extension DTB {
    
    public protocol UnboxOptionalOrDefault {
        
        /// [HACK] 取名和 Wrapper 的泛型相同，省去 typealias
        associatedtype Base
        
        func isEmpty() -> Bool
        
        func or(_ value: Base) -> Base
        
        func orEmpty() -> Base
    }
}

