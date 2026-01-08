//
//  DefaultSceneProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/28
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// Current scene in general.
    ///
    /// 默认实现注定无法准确，用前请读最佳实践。
    ///
    /// [best practices](https://darkthanblack.github.io/blogs/04-bp-keywindow)
    /// [refer](https://stackoverflow.com/questions/57134259)
    @available(iOS 13.0, *)
    public final class DefaultSceneProvider: Providers.SceneProvider {
        
        private weak var scene: UIWindowScene? = nil
        
        public init(_ scene: UIWindowScene? = nil) {
            self.scene = scene
        }
        
        @available(iOS 13.0, *)
        public func keyWindowScene() -> UIWindowScene? {
            return scene ?? UIApplication
                .shared
                .connectedScenes
                .compactMap({ ($0 as? UIWindowScene) })
                .first
        }
    }
}
