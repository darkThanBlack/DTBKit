//
//  ButtonStyle.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/10
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension StaticWrapper where T == DTB.ButtonStyle {
    
    public func create(_ param: Any?) -> DTB.ButtonStyle? {
        if let p = DTB.app.get(DTB.Providers.buttonStyleKey), let style = p.create(param) {
            return style
        }
        if let dict = param as? [String: Any], let style = DTB.ButtonStyle(dict: dict) {
            return style
        }
        return nil
    }
}

extension DTB {
    
    public struct ButtonStyle: Structable {
        
        public var backgroundColor: UIColor?
        
        public var contentEdgeInsets: UIEdgeInsets?
        
        public var title: String?
        
        public var textColor: UIColor?
        
        public var font: UIFont?
        
        public var attributedText: NSAttributedString?
        
        public var image: UIImage?
        
        public var tintColor: UIColor?
        
        public var imageSize: CGSize?
        
        public var imageDirection: DTB.FourDirection?
        
        public var imageOffset: CGVector?
        
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
            title: String? = nil,
            textColor: UIColor? = nil,
            font: UIFont? = nil,
            attributedText: NSAttributedString? = nil,
            image: UIImage? = nil,
            tintColor: UIColor? = nil,
            imageSize: CGSize? = nil,
            imageDirection: DTB.FourDirection? = nil,
            imageOffset: CGVector? = nil,
            shape: DTB.ShapeStyle? = nil,
            gradient: DTB.GradientStyle? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.contentEdgeInsets = contentEdgeInsets
            self.title = title
            self.textColor = textColor
            self.font = font
            self.attributedText = attributedText
            self.image = image
            self.tintColor = tintColor
            self.imageSize = imageSize
            self.imageDirection = imageDirection
            self.imageOffset = imageOffset
            self.shape = shape
            self.gradient = gradient
            
            friendlyParser()
        }
        
        public init?(dict: [String: Any]?) {
            guard let dict = dict else { return nil }
            
            // 属性字符串一般不在 JSON 中解析，置 nil
            self.attributedText = nil
            
            self.backgroundColor = .dtb.create(dict["backgroundColor"])
            self.shape = .dtb.create(dict["shape"])
            self.gradient = .dtb.create(dict["gradient"])
            
            // 标题
            self.title = dict["title"] as? String
            
            // 字体
            if let f = dict["font"] {
                self.font = .dtb.create(f)
            }
            
            // 文字颜色
            if let c = dict["textColor"] {
                self.textColor = .dtb.create(c)
            }
            
            // 图片
            self.image = .dtb.create(dict["image"])
            
            //
            self.tintColor = .dtb.create(dict["tintColor"])

            // 内边距
            //
            // 额外解析: 兼容多个字段名
            self.contentEdgeInsets = [
                "contentEdgeInsets",
                "padding"
            ].compactMap({ DTB.any.uiEdgeInsets(dict[$0]) }).first
            
            // 图片尺寸
            self.imageSize = DTB.any.cgSize(dict["imageSize"])
            
            // 图片方向
            self.imageDirection = DTB.FourDirection(rawValue: (dict["imageDirection"] as? String) ?? "")
            
            // 图片偏移
            self.imageOffset = DTB.any.cgVector(dict["imageOffset"])
            
            friendlyParser()
        }
        
    }
    
}
