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

@available(iOS 13.0, *)
public protocol SceneProvider {
    
    @available(iOS 13.0, *)
    func keyWindowScene() -> UIWindowScene?
}

@available(iOS 13.0, *)
extension StaticWrapper where T: UIWindowScene {
    
    /// Current scene in general.
    ///
    /// 默认实现注定无法准确，用前请读最佳实践。
    ///
    /// [best practices](https://darkthanblack.github.io/blogs/04-bp-keywindow)
    /// [refer](https://stackoverflow.com/questions/57134259)
    @available(iOS 13.0, *)
    public func current() -> UIWindowScene? {
        if let scene = DTB.app.get(DTB.BasicInterface.sceneKey)?.keyWindowScene() {
            return scene
        }
        
        return UIApplication
            .shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene) })
            .first
    }
}
