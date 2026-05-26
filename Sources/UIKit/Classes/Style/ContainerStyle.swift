//
//  ContainerModel.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public struct ContainerStyle: ContainerUI {
        
        public var margin: UIEdgeInsets
        
        public var padding: UIEdgeInsets
        
        public var autoCorners: Bool
        
        public var shape: (any DTB.ShapeUI)?
        
        public init(
            margin: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0),
            padding: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0),
            autoCorners: Bool = true,
            shape: (any DTB.ShapeUI)? = nil
        ) {
            self.margin = margin
            self.padding = padding
            self.autoCorners = autoCorners
            self.shape = shape
        }
    }
    
}

