//
//  Toast+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/3/25
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Toast 抽象接口
///
/// See more details in ``dtbkit_adapter.md``
public protocol DTBKitToast {
    
    associatedtype ToastMessageType = String
    
    associatedtype ToastExtraParam = AnyObject
    
    /// Show Android style toast | 轻提示 收口
    func toast(_ message: ToastMessageType?, _ param: ToastExtraParam?)
}

extension DTBKitToast {
    
    public func toast(_ message: ToastMessageType?, _ param: ToastExtraParam? = nil) {
        assert(false, "this is abstract func")
    }
}
