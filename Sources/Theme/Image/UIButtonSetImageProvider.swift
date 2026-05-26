//
//  UIButtonSetImageProvider.swift
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
    
    public static let uiButtonSetImageKey = DTB.ConstKey<any UIButtonSetImageProvider>("dtb.providers.uibutton.setimage")
    
    public protocol UIButtonSetImageProvider {
        
        func setup(button: UIButton, param: Any?, completedHandler: ((Any?) -> ())?)
    }
}
