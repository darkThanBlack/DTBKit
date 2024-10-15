//
//  DTBKitAdapter.swift
//  DTBKit
//
//  Created by moonShadow on 2024/10/12
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Allow change some func behavior.
///
/// 有些方法使用频率高，但又注定与业务高度绑定，使用接口形式以允许重载。
///
/// 详情参见 ``dtbkit_adapter.md``

extension DTBKitStaticWrapper: DTBKitAdapterForUIColor where T: UIColor {}

extension DTBKitStaticWrapper: DTBKitAdapterForString where T == String {}

extension DTBKitStaticWrapper: DTBKitAdapterForHUD where T: UIView {}

extension DTBKitWrapper: DTBKitAdapterForHUD where Base: UIView {}

extension DTBKitStaticWrapper: DTBKitAdapterForToast where T: UIView {}

extension DTBKitWrapper: DTBKitAdapterForToast where Base: UIView {}

@available(iOS 13.0, *)
extension DTBKitStaticWrapper: DTBKitAdapterForUIWindowScene where T: UIWindowScene {}

extension DTBKitStaticWrapper: DTBKitAdapterForUIWindow where T: UIWindow {}

// MARK: -

/// See more details in ``dtbkit_adapter.md``
public protocol DTBKitAdapterForHUD {
    
    associatedtype HUDParam = String
    
    /// Show progress HUD | 菊花圈 收口
    func showHUD(_ message: HUDParam?)
    
    /// Hide progress HUD | 菊花圈 收口
    func hideHUD()
}

extension DTBKitAdapterForHUD {
    
    public func showHUD(_ message: HUDParam? = nil) {
        assert(false, "implement your own HUD")
    }
    
    public func hideHUD() {
        assert(false, "implement your own HUD")
    }
}

/// See more details in ``dtbkit_adapter.md``
public protocol DTBKitAdapterForToast {
    
    associatedtype ToastParam = String
    
    /// Show Android style toast | 轻提示 收口
    func toast(_ message: ToastParam?)
}

extension DTBKitAdapterForToast {
    
    public func toast(_ message: ToastParam?) {
        assert(false, "implement your own toast")
    }
}

/// See more details in ``dtbkit_adapter.md``
public protocol DTBKitAdapterForAlert {}
