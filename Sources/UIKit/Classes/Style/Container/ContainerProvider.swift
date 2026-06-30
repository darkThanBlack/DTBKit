//
//  ContainerProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/30
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Providers {
    
    public static let containerStyleKey = DTB.ConstKey<any ContainerStyleProvider>("dtb.providers.style.container")
    
    public protocol ContainerStyleProvider {
        func create(_ param: Any?) -> DTB.ContainerStyle?
    }
}
