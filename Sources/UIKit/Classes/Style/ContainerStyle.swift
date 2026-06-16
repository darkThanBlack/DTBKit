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

extension DTB.ContainerStyle {
    
    public static func singleCard() -> DTB.ContainerStyle {
        return DTB.ContainerStyle(
            margin: UIEdgeInsets(top: 8.0, left: 16.0, bottom: 4.0, right: 16.0),
            padding: UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0),
            shape: DTB.ShapeStyle(
                corners: [.allCorners],
                radius: .fixed(12.0),
                fillColor: .white,
                lineWidth: 0.0
            )
        )
    }
    
    public static func listCard(_ indexOrder: DTB.IndexOrder = .isMiddle) -> DTB.ContainerStyle {
        return DTB.ContainerStyle(
            margin: UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0),
            padding: UIEdgeInsets(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0),
            shape: DTB.ShapeStyle(
                corners: indexOrder.verticalCorners,
                radius: .fixed(12.0),
                fillColor: .white,
                lineWidth: 0.0
            )
        )
    }
}

extension DTB {
    
    /// 自定义容器
    public struct ContainerStyle {
        
        /// 外间距
        public var margin: UIEdgeInsets?
        
        /// 内间距
        public var padding: UIEdgeInsets?
        
        /// CAShapeLayer
        public var shape: ShapeStyle?
        
        public init(
            margin: UIEdgeInsets? = nil,
            padding: UIEdgeInsets? = nil,
            shape: ShapeStyle? = nil
        ) {
            self.margin = margin
            self.padding = padding
            self.shape = shape
        }
    }
}

