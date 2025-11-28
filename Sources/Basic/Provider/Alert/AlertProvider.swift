//
//  AlertProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/10/10
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Providers {
    
    public static let alertKey = DTB.ConstKey<any AlertProvider>("dtb.providers.alert")
    
    public protocol AlertProvider {
        
        func show(_ params: Any?)
    }
}

extension DTB {
    
    @inline(__always)
    public static func alert() -> Wrapper<AlertCreater> {
        return AlertCreater().dtb
    }
}
