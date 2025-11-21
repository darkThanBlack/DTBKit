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

public class DefaultAlertProvider: AlertProvider {
    
    public func show(_ params: AlertCreater) {
        let alert = UIAlertController(title: params.title, message: params.message, preferredStyle: .alert)
        params.actions.forEach({ act in
            alert.addAction(UIAlertAction(title: act.title, style: .default, handler: { _ in
                act.handler?(act)
            }))
        })
        UIViewController.dtb.topMost()?.present(alert, animated: true)
    }
}
