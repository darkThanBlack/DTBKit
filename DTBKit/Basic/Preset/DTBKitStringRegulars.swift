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

/// To wrapper exp string
public struct DTBKitStringRegulars {
    
    public let exp: String
    
    init(exp: String) {
        self.exp = exp
    }
}

/// Default regular
extension DTBKitStringRegulars {
    
    /// "^\\d{11}$"
    public static var phoneNumber: Self {
        return DTBKitStringRegulars(exp: "^\\d{11}$")
    }
    
    /// "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
    public static var password_6_16_A_Z: Self {
        return DTBKitStringRegulars(exp: "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$")
    }
}
