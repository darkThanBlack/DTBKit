//
//  UIWindowScene+DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2024/10/12
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// See more details in ``dtbkit_adapter.md``
@available(iOS 13.0, *)
public protocol DTBKitAdapterForUIWindowScene {
    
    /// Current scene in general for nonscene-based app.
    ///
    /// 默认实现注定无法准确，参见 ``keyWindow()``
    @available(iOS 13.0, *)
    func keyScene() -> UIWindowScene?
}

@available(iOS 13.0, *)
extension DTBKitAdapterForUIWindowScene {
    
    @available(iOS 13.0, *)
    public func keyScene() -> UIWindowScene? {
        return UIApplication
            .shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene) })
            .first
    }
}

