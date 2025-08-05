//
//  DTBKitToast.swift
//  DTBKit
//
//  Created by moonShadow on 2023/12/29
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
public protocol ToastProvider {
    
    func toast(on view: UIView?, param: Any?)
}

extension StaticWrapper where T: UIView {
    
    /// Show toast with provider.
    ///
    /// toast 调用收束
    public func toast(_ param: Any?) {
        DTB.app.get(DTB.BasicInterface.toastKey)?.toast(on: nil, param: param)
    }
}

extension Wrapper where Base: UIView {
    
    /// Show toast with provider.
    ///
    /// toast 调用收束
    @discardableResult
    public func toast(_ param: Any?) -> Self {
        DTB.app.get(DTB.BasicInterface.toastKey)?.toast(on: value, param: param)
        return self
    }
}
