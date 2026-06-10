//
//  ButtonStyleProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/10
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Providers {
    
    public static let buttonStyleKey = DTB.ConstKey<any ButtonStyleProvider>("dtb.providers.style.button")
    
    public protocol ButtonStyleProvider {
        
        func create(_ param: Any?) -> DTB.ButtonStyle?
    }
}
