//
//  Regulars+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/18
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// String regular candy | 正则表达式定义
    ///
    /// 参见 ``isRegular``
    ///
    /// Add your custom regular:
    /// ```
    ///     extension DTB.Regulars {
    ///         public static func phone() -> Self {}
    ///     }
    ///
    ///     let success: Bool = "123".dtb.isRegular(.phone())
    /// ```
    public struct Regulars {
        
        public let exp: String
        
        public init(_ exp: String) {
            self.exp = exp
        }
    }
}
