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
        }
        
        
        public init?(dict: [String: Any]?) {
            guard let dict = dict else { return nil }
            
            // 属性字符串一般不在 JSON 中解析，置 nil
            self.attributedText = nil
            
            if let c = dict["backgroundColor"] {
                self.backgroundColor = .dtb.create(c)
            }
            
            self.shape = .dtb.create(dict["shape"])
            self.gradient = .dtb.create(dict["gradient"])
            
            // 额外解析: 让 fillColor 未设置时，沿用 backgroundColor
            if self.shape != nil, self.shape?.fillColor == nil, let color = self.backgroundColor {
                self.shape?.fillColor = color
            }
            
            // 额外解析: 让 gradient.shapeMask 未设置时，沿用本身的 shape 作为 mask
            if self.gradient != nil, self.gradient?.shapeMask == nil {
                self.gradient?.shapeMask = self.shape
            }
            
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
            
            if let c = dict["tintColor"] {
                self.tintColor = .dtb.create(c)
            }
            
            // 内边距
            self.contentEdgeInsets = {
                // 额外解析: 兼容多个字段名
                if let insetsDict = [
                    "contentEdgeInsets",
                    "padding"
                ].compactMap({ dict[$0] as? [String: CGFloat] }).first {
                    return UIEdgeInsets(
                        top: insetsDict["top"] ?? 0,
                        left: insetsDict["left"] ?? 0,
                        bottom: insetsDict["bottom"] ?? 0,
                        right: insetsDict["right"] ?? 0
                    )
                }
                return nil
            }()
            
            // 图片尺寸
            self.imageSize = {
                if let sizeDict = dict["imageSize"] as? [String: CGFloat] {
                    return CGSize(
                        width: sizeDict["width"] ?? 0,
                        height: sizeDict["height"] ?? 0
                    )
                }
                return nil
            }()
            
            // 图片方向
            self.imageDirection = {
                if let raw = dict["imageDirection"] as? String {
                    return DTB.FourDirection(rawValue: raw)
                }
                return nil
            }()
            
            // 图片偏移
            self.imageOffset = {
                if let offsetDict = dict["imageOffset"] as? [String: CGFloat] {
                    return CGVector(
                        dx: offsetDict["dx"] ?? 0,
                        dy: offsetDict["dy"] ?? 0
                    )
                }
                return nil
            }()
            
        }
        
    }
    
}
