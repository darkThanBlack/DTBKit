//
//  RemoteImageProvider.swift
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
    
    public static let remoteImageKey = DTB.ConstKey<any RemoteImageProvider>("dtb.providers.remote.image")
    
    public protocol RemoteImageProvider {
        
        func create(_ param: Any?) -> UIImage?
    }
}
