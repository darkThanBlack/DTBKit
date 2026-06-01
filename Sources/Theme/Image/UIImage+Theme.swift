//
//  UIImage+UI.swift
//  Pods
//
//  Created by moonShadow on 2026/5/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

///
extension StaticWrapper where T: UIImage {
    
    /// 加载本地图片
    ///
    /// - bundle: same as Bundle.dtb.create
    public func local(_ param: Any?, bundle: Any? = nil) -> UIImage? {
        if let p = DTB.Providers.get(DTB.Providers.localImageKey), let image = p.create(param, bundle: bundle) {
            return image
        }
        return nil
    }
    
    /// 加载网络图片
    ///
    ///
    public static func remote(_ value: Any?, completedHandler: ((Result<UIImage, Error>) -> ())?) {
        if let p = DTB.Providers.get(DTB.Providers.remoteImageKey) {
            p.remote(value, completedHandler: completedHandler)
        }
    }
    
}
