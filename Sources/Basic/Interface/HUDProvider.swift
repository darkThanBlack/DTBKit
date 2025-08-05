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

/// 
public protocol HUDProvider {
    
    func showHUD(on view: UIView?, param: Any?)
    
    func hideHUD(on view: UIView?, param: Any?)
}

extension StaticWrapper where T: UIView {
    
    /// Show HUD with provider.
    ///
    /// HUD 调用收束
    public func showHUD(_ param: Any? = nil) {
        DTB.app.get(DTB.BasicInterface.hudKey)?.showHUD(on: nil, param: param)
    }
    
    /// Show HUD with provider.
    ///
    /// HUD 调用收束
    public func hideHUD(_ param: Any? = nil) {
        DTB.app.get(DTB.BasicInterface.hudKey)?.hideHUD(on: nil, param: param)
    }
}

extension Wrapper where Base: UIView {
    
    /// Show HUD with provider.
    ///
    /// HUD 调用收束
    @discardableResult
    public func showHUD(_ param: Any? = nil) -> Self {
        DTB.app.get(DTB.BasicInterface.hudKey)?.showHUD(on: value, param: param)
        return self
    }
    
    /// Show HUD with provider.
    ///
    /// HUD 调用收束
    @discardableResult
    public func hideHUD(_ param: Any? = nil) -> Self {
        DTB.app.get(DTB.BasicInterface.hudKey)?.hideHUD(on: value, param: param)
        return self
    }
}
