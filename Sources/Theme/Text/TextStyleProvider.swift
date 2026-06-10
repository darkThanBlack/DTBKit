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
    
    public static let textStyleKey = DTB.ConstKey<any TextStyleProvider>("dtb.providers.style.text")
    
    public protocol TextStyleProvider {
        
        func create(_ param: Any?) -> DTB.TextStyle?
    }
}
