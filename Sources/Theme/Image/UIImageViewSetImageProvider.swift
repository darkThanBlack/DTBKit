//
//  UIImageViewSetImageProvider.swift
//  Pods
//
//  Created by moonShadow on 2026/5/26
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Providers {
    
    public static let uiImageViewSetImageKey = DTB.ConstKey<any UIImageViewSetImageProvider>("dtb.providers.uiimageview.setimage")
    
    public protocol UIImageViewSetImageProvider {
        
        func setup(imageView: UIImageView, param: Any?, completedHandler: ((Any?) -> ())?)
    }
}
