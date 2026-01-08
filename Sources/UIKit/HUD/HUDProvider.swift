//
//  DTBKitHUD.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/12
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Providers {
    
    public static let hudKey = DTB.ConstKey<any HUDProvider>("dtb.providers.hud")
    
    ///
    public protocol HUDProvider {
        
        func showHUD(on view: UIView?, param: Any?)
        
        func hideHUD(on view: UIView?, param: Any?)
    }
}

extension StaticWrapper where T: UIView {
    
    /// Show HUD with provider.
    ///
    /// HUD 调用收束
    public func showHUD(_ param: Any? = nil) {
        DTB.Providers.get(DTB.Providers.hudKey)?.showHUD(on: nil, param: param)
    }
    
    /// Show HUD with provider.
    ///
    /// HUD 调用收束
    public func hideHUD(_ param: Any? = nil) {
        DTB.Providers.get(DTB.Providers.hudKey)?.hideHUD(on: nil, param: param)
    }
}

extension Wrapper where Base: UIView {
    
    /// Show HUD with provider.
    ///
    /// HUD 调用收束
    @discardableResult
    public func showHUD(_ param: Any? = nil) -> Self {
        DTB.Providers.get(DTB.Providers.hudKey)?.showHUD(on: value, param: param)
        return self
    }
    
    /// Show HUD with provider.
    ///
    /// HUD 调用收束
    @discardableResult
    public func hideHUD(_ param: Any? = nil) -> Self {
        DTB.Providers.get(DTB.Providers.hudKey)?.hideHUD(on: value, param: param)
        return self
    }
}
