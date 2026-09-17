//
//  DefaultAlertProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/10/10
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    ///
    public final class DefaultAlertProvider: Providers.AlertProvider {
        
        public init() {}
        
        public func showAlert(on viewController: UIViewController?, param: Any?) {
            guard let sourceVC = viewController ?? UIViewController.dtb.topMost() else {
                return
            }
            if let targetVC = param as? UIViewController {
                sourceVC.present(targetVC, animated: true)
                return
            }
            if let creater = param as? DTB.Alert {
                let alert = DTB.DefaultAlertViewController(creater: creater)
                sourceVC.present(alert, animated: true)
                return
            }
            if let creater = param as? DTB.AttributeAlert {
                let alert = DTB.DefaultAlertViewController(creater: creater)
                sourceVC.present(alert, animated: true)
            }
        }
    }
}
