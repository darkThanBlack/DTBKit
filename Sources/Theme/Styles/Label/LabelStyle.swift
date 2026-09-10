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

        /// Simple replacement for .dtb.create
        public static func style(_ param: Any?) -> DTB.LabelStyle? {
            if let p = DTB.app.get(DTB.Providers.stylesKey), let style = p.createLabelStyle(param) {
                return style
            }
            if let dict = param as? [String: Any], let style = DTB.LabelStyle(dict: dict) {
                return style
            }
            return nil
        }

        public init?(dict: [String: Any]?) {
            guard let dict = dict else { return nil }

            self.backgroundColor = .dtb.create(nullable: dict["backgroundColor"])
            self.shape = .style(dict["shape"])
            self.gradient = .style(dict["gradient"])

            // 字体
            if let f = dict["font"] {
                self.font = .dtb.create(f)
            }

            // 文字颜色
            if let c = dict["textColor"] {
                self.textColor = .dtb.create(c)
            }

            // 内边距
            //
            // 额外解析: 兼容多个字段名
            self.contentEdgeInsets = [
                "contentEdgeInsets",
                "padding"
            ].compactMap({ DTB.any.uiEdgeInsets(dict[$0]) }).first

            // 行数
            self.numberOfLines = DTB.any.int(dict["numberOfLines"])

            // 对齐方式
            self.textAlignment = Self.parseTextAlignment(dict["textAlignment"] as? String)

            friendlyParser()
        }

        private static func parseTextAlignment(_ raw: String?) -> NSTextAlignment? {
            switch raw?.lowercased() ?? "" {
            case "left":      return .left
            case "center":    return .center
            case "right":     return .right
            case "justified": return .justified
            case "natural":   return .natural
            default:          return nil
            }
        }
    }
}
