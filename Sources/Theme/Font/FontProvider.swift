//
//  FontProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/10/9
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Providers {
    
    public static let fontKey = DTB.ConstKey<any FontProvider>("dtb.providers.style.font")
    
    ///
    public protocol FontProvider {
        
        func create(_ param: Any?) -> UIFont?
    }
}
