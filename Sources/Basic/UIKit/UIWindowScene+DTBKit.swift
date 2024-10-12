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

