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
                fillColor: .dtb.create("bg2"),
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
                fillColor: .dtb.create("bg2"),
                lineWidth: 0.0
            )
        )
    }
}

extension DTB {
    
    /// 自定义容器，取决于对应控件的内部实现
    public struct ContainerStyle: Structable, Equatable {
        
        /// 外间距
        public var margin: UIEdgeInsets?
        
        /// 内间距
        public var padding: UIEdgeInsets?
        
        ///
        public var backgroundColor: UIColor?
        
        ///
        public var shape: DTB.ShapeStyle?
        
        ///
        public var gradient: DTB.GradientStyle?
        
        public init(
            margin: UIEdgeInsets? = nil,
            padding: UIEdgeInsets? = nil,
            backgroundColor: UIColor? = nil,
            shape: DTB.ShapeStyle? = nil,
            gradient: DTB.GradientStyle? = nil
        ) {
            self.margin = margin
            self.padding = padding
            self.backgroundColor = backgroundColor
            self.shape = shape
            self.gradient = gradient
        }
        
        public init?(dict: [String: Any]?) {
            guard let dict = dict else { return nil }
            
            func insets(from data: [String: Any]?) -> UIEdgeInsets? {
                if let data = data,
                   let top = DTB.any.double(data["top"]),
                   let left = DTB.any.double(data["left"]),
                   let bottom = DTB.any.double(data["bottom"]),
                   let right = DTB.any.double(data["right"]) {
                    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
                }
                return nil
            }
            
            self.margin = insets(from: dict["margin"] as? [String: Any])
            self.padding = insets(from: dict["padding"] as? [String: Any])
            self.backgroundColor = .dtb.create(dict["backgroundColor"])
            self.shape = .dtb.create(dict["shape"])
            self.gradient = .dtb.create(dict["gradient"])
        }
    }
}

