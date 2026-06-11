//
//  GradientStyleProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/11
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.Providers {
    
    public static let gradientStyleKey = DTB.ConstKey<any GradientStyleProvider>("dtb.providers.style.gradient")
    
    public protocol GradientStyleProvider {
        func create(_ param: Any?) -> DTB.GradientStyle?
    }
}
