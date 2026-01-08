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
    
    public final class DefaultAlertProvider: Providers.AlertProvider {
        
        public init() {}
        
        public func show(_ params: Any?) {
            guard let params = params as? AlertCreater else { return }
            let alert = UIAlertController(title: params.title, message: params.message, preferredStyle: .alert)
            params.actions.forEach({ act in
                alert.addAction(UIAlertAction(title: act.title, style: .default, handler: { _ in
                    act.handler?(act)
                }))
            })
            UIViewController.dtb.topMost()?.present(alert, animated: true)
        }
    }
}
