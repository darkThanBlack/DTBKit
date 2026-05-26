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
    
    public func create(_ param: Any?) -> UIImage? {
        if let p = DTB.Providers.get(DTB.Providers.localImageKey), let image = p.create(param, bundle: nil) {
            return image
        }
        return nil
    }
    
}
