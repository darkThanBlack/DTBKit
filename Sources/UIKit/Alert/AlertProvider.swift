//
//  AlertProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/10/10
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB.Providers {
    
    public static let alertKey = DTB.ConstKey<any AlertProvider>("dtb.providers.alert")
    
    public protocol AlertProvider {
        
        func showAlert(on viewController: UIViewController?, param: Any?)
    }
}

extension StaticWrapper where T: UIViewController {
    
    /// Show Alert with provider.
    ///
    /// Alert 调用收束
    public func showAlert(on viewController: UIViewController? = nil, param: Any?) {
        DTB.Providers.get(DTB.Providers.alertKey)?.showAlert(on: viewController, param: param)
    }
}

extension Wrapper where Base: UIViewController {
    
    /// Show Alert with provider.
    ///
    /// Alert 调用收束
    public func showAlert(_ param: Any?) {
        DTB.Providers.get(DTB.Providers.alertKey)?.showAlert(on: me, param: param)
    }
}
