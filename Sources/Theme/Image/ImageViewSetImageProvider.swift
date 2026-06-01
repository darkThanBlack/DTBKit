//
//  ImageViewSetImageProvider.swift
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
    
    public static let imageViewSetImageKey = DTB.ConstKey<any ImageViewSetImageProvider>("dtb.providers.imageview.setimage")
    
    public protocol ImageViewSetImageProvider {
        
        func setImage(on imageView: UIImageView, url: Any?, placeholder: Any?, completedHandler: ((Result<UIImage, Error>) -> Void)?)
    }
}
