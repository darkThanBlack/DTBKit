//
//  TextStyleProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB.Providers {
    
    public static let localImageKey = DTB.ConstKey<any LocalImageProvider>("dtb.providers.local.image")
    
    public protocol LocalImageProvider {
        
        func create(_ param: Any?, bundle: Any?) -> UIImage?
    }
}
