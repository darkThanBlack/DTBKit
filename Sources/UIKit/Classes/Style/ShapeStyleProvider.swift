//
//  ShapeStyleProvider.swift
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
    
    public static let shapeStyleKey = DTB.ConstKey<any ShapeStyleProvider>("dtb.providers.style.shape")
    
    public protocol ShapeStyleProvider {
        func create(_ param: Any?) -> DTB.ShapeStyle?
    }
}
