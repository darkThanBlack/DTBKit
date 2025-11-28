//
//  XMKitToast+Sport.swift
//  XMKit
//
//  Created by moonShadow on 2023/12/29
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit
import Toast_Swift

extension DTB {
    
    ///
    public class DefaultToastProvider: DTB.Providers.ToastProvider {
        
        public init() {}
        
        public func toast(on view: UIView?, param: Any?) {
            DispatchQueue.main.async {
                guard let depends = view ?? UIViewController.dtb.topMost()?.view else {
                    return
                }
                guard let message = param as? String, message.isEmpty == false else {
                    return
                }
                depends.makeToast(message, position: .center)
            }
        }
    }
}
