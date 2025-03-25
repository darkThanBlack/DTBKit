//
//  HUD+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/3/25
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// HUD 抽象接口
///
/// See more details in ``dtbkit_adapter.md``
public protocol DTBKitHUD {
    
    associatedtype HUDMessageType = String
    
    associatedtype HUDExtraParam = AnyObject
    
    /// Show progress HUD | 菊花圈 收口
    func showHUD(_ message: HUDMessageType?, _ param: HUDExtraParam?)
    
    /// Hide progress HUD | 菊花圈 收口
    func hideHUD(_ param: HUDExtraParam?)
}

extension DTBKitHUD {
    
    public func showHUD(_ message: HUDMessageType? = nil, _ param: HUDExtraParam? = nil) {
        assert(false, "this is abstract func")
    }
    
    public func hideHUD(_ param: HUDExtraParam? = nil) {
        assert(false, "this is abstract func")
    }
}

