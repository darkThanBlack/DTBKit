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

//public typealias DTBKitAdapter2 = DTBKitAdapterForUIWindowScene & DTBKitAdapterForUIWindow

/// Allow change some func behavior.
///
/// 有些方法使用频率高，但又注定与业务高度绑定，使用接口形式以允许重载。
///
/// [refer | 语法参考](https://zhuanlan.zhihu.com/p/80672557)

// MARK: - UIColor

public protocol DTBKitAdapterForUIColor {
    
    associatedtype ColorParam = Int64
    
    /// 色值生成收口
    func create(_ key: ColorParam) -> UIColor
}

extension DTBKitStaticWrapper: DTBKitAdapterForUIColor where T: UIColor {}

// MARK: - String

public protocol DTBKitAdapterForString {
    
    associatedtype StringParam = String
    
    /// 文本生成收口
    func create(_ key: StringParam) -> String
}

extension DTBKitStaticWrapper: DTBKitAdapterForString where T == String {}

// MARK: - HUD

public protocol DTBKitAdapterForHUD {
    
    associatedtype HUDParam = String
    
    /// Show hud on ``UIViewController.dtb.topMost?.view``
    func showHUD(_ message: HUDParam?)
    
    /// Hide hud on ``UIViewController.dtb.topMost?.view``
    func hideHUD()
}

extension DTBKitAdapterForHUD {
    
    public func showHUD(_ message: HUDParam? = nil) {
        print("show hud needed")
    }
    
    public func hideHUD() {
        print("hide hud needed")
    }
}

extension DTBKitStaticWrapper: DTBKitAdapterForHUD where T: UIView {}

extension DTBKitWrapper: DTBKitAdapterForHUD where Base: UIView {}

// MARK: - Toast

public protocol DTBKitAdapterForToast {
    
    associatedtype ToastParam = String
    
    func toast(_ message: ToastParam?)
}

extension DTBKitAdapterForToast {
    
    public func toast(_ message: ToastParam?) {
        guard message != nil else { return }
        print("make toast: \(message as? String ?? "")")
    }
}

// MARK: - UIWindowScene

@available(iOS 13.0, *)
public protocol DTBKitAdapterForUIWindowScene {
    
    /// Current scene in general for nonscene-based app.
    ///
    /// 默认实现注定无法准确，参见 ``keyWindow()``
    @available(iOS 13.0, *)
    func keyScene() -> UIWindowScene?
}

@available(iOS 13.0, *)
extension DTBKitStaticWrapper: DTBKitAdapterForUIWindowScene where T: UIWindowScene {}

// MARK: - UIWindow

public protocol DTBKitAdapterForUIWindow {
    
    /// Current window in general for nonscene-based app. I recommended you override this method and get it with hard-coding.
    ///
    /// 默认实现注定无法准确；推荐您重载该方法，通过 tag 写死来获取。
    ///
    /// e.g.
    /// ```
    /// extension XMKitStaticWrapper where T: UIWindow {
    ///
    ///     public func keyWindow() -> UIWindow? {
    ///         return UIApplication.shared.windows.first(where: { $0.tag == MyApp.windowTag })
    ///     }
    /// }
    /// ```
    ///
    /// [best practices | 最佳实践](https://darkthanblack.github.io/blogs/04-bp-keywindow)
    ///
    /// [refer | 一些讨论](https://stackoverflow.com/questions/57134259)
    func keyWindow() -> UIWindow?
}

extension DTBKitStaticWrapper: DTBKitAdapterForUIWindow where T: UIWindow {}
