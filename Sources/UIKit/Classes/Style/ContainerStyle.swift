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
    
    /// 自定义容器
    public struct ContainerStyle: Equatable {
        
        /// 外间距
        public var margin: UIEdgeInsets
        
        /// 内间距
        public var padding: UIEdgeInsets
        
        /// CAShapeLayer
        public var shape: ShapeStyle?
        
        public init(
            margin: UIEdgeInsets = .zero,
            padding: UIEdgeInsets = .zero,
            shape: ShapeStyle? = nil
        ) {
            self.margin = margin
            self.padding = padding
            self.shape = shape
        }
    }
}

