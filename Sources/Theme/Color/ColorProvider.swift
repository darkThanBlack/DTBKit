//
//  DTBKitColor.swift
//  DTBKit
//
//  Created by moonShadow on 2023/12/28
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Providers {
    
    public static let colorKey = DTB.ConstKey<any ColorProvider>("dtb.providers.color")
    
    ///
    public protocol ColorProvider {
        
        func create(_ param: Any?) -> UIColor?
    }
}
