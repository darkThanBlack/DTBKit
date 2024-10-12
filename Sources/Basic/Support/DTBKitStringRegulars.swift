//
//  DTBKitStringRegulars.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/11/17
//  Copyright © 2023 darkThanBlack. All rights reserved.
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
    /// e.g.
    /// ```
    ///     extension XM.Regulars {
    ///         public static func phone() -> Self {}
    ///     }
    ///
    ///     let success: Bool = "123".xm.isRegular(.phone())
    /// ```
    public struct Regulars {
        
        public let exp: String
        
        init(exp: String) {
            self.exp = exp
        }
    }
}

extension DTB.Regulars {
    
    /// "^\\d{11}$"
    public static var phoneNumber: Self {
        return .init(exp: "^\\d{11}$")
    }
    
    /// "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
    public static var password_6_16_A_Z: Self {
        return .init(exp: "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$")
    }
}
