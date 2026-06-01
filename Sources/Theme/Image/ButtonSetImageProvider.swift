//
//  ButtonSetImageProvider.swift
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
    
    public static let buttonSetImageKey = DTB.ConstKey<any ButtonSetImageProvider>("dtb.providers.button.setimage")
    
    public protocol ButtonSetImageProvider {
        
        func setImage(on button: UIButton, url: Any?, placeholder: Any?, completedHandler: ((Result<UIImage, Error>) -> Void)?)
    }
}
