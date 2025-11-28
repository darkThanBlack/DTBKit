//
//  SceneProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/7/31
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Providers {
    
    @available(iOS 13.0, *)
    public static let sceneKey = DTB.ConstKey<(any DTB.Providers.SceneProvider)>("dtb.providers.scene")
    
    @available(iOS 13.0, *)
    public protocol SceneProvider {
        
        @available(iOS 13.0, *)
        func keyWindowScene() -> UIWindowScene?
    }
}

@available(iOS 13.0, *)
extension StaticWrapper where T: UIWindowScene {
    
    /// Current scene in general.
    @available(iOS 13.0, *)
    @inline(__always)
    public func keyWindowScene() -> UIWindowScene? {
        return DTB.Providers.get(DTB.Providers.sceneKey)?.keyWindowScene()
    }
}
