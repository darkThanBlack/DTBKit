//
//  LabelStyle.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/9
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {

    /// 对标 ``DTB.ButtonStyle``，但 label 无法一一镜像 UILabel 的 API，
    /// 所以这里只收纳「可主题化」的通用外观，其余属性交给 ``DTB.Label.update(_:)``。
    ///
    /// 不响应 `margin`：自尺寸 label 的 margin 属于父布局，仅保留内容内缩 `contentEdgeInsets`（= padding）。
    public struct LabelStyle {

        public var backgroundColor: UIColor?

        public var contentEdgeInsets: UIEdgeInsets?

        public var textColor: UIColor?

        public var font: UIFont?

        public var numberOfLines: Int?

        public var textAlignment: NSTextAlignment?

        public var shape: DTB.ShapeStyle?

        public var gradient: DTB.GradientStyle?

        // 额外解析
        private mutating func friendlyParser() {
            // 让 fillColor 未设置时，沿用 backgroundColor
            if self.shape != nil, self.shape?.fillColor == nil, let color = self.backgroundColor {
                self.shape?.fillColor = color
            }

            // 让 gradient.shapeMask 未设置时，沿用本身的 shape 作为 mask
            if self.gradient != nil, self.gradient?.shapeMask == nil {
                self.gradient?.shapeMask = self.shape
            }
        }

        public init(
            backgroundColor: UIColor? = nil,
            contentEdgeInsets: UIEdgeInsets? = nil,
            textColor: UIColor? = nil,
            font: UIFont? = nil,
            numberOfLines: Int? = nil,
            textAlignment: NSTextAlignment? = nil,
            shape: DTB.ShapeStyle? = nil,
            gradient: DTB.GradientStyle? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.contentEdgeInsets = contentEdgeInsets
            self.textColor = textColor
            self.font = font
            self.numberOfLines = numberOfLines
            self.textAlignment = textAlignment
            self.shape = shape
            self.gradient = gradient

            friendlyParser()
        }

    }
}
