//
//  StylesProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2026/8/8
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB.Providers {
    
    public static let stylesKey = DTB.ConstKey<any StylesProvider>("dtb.providers.styles")
    
    public protocol StylesProvider {
        
        func createShapeStyle(_ param: Any?) -> DTB.ShapeStyle?
        
        func createGradientStyle(_ param: Any?) -> DTB.GradientStyle?
        
        func createTextStyle(_ param: Any?) -> DTB.TextStyle?
        
        func createContainerStyle(_ param: Any?) -> DTB.ContainerStyle?
        
        func createButtonStyle(_ param: Any?) -> DTB.ButtonStyle?
    }
}
