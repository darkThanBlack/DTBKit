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

extension DTB.ButtonStyle: Structable {}

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
    
    public struct ButtonStyle {
        
        public var title: String?
        
        public var textColor: UIColor?
        
        public var font: UIFont?
        
        public var attributedText: NSAttributedString?
        
        public var image: UIImage?
        
        public var contentEdgeInsets: UIEdgeInsets?
        
        public var imageSize: CGSize?
        
        public var imageDirection: DTB.FourDirection?
        
        public var imageOffset: CGVector?
        
        public init(title: String? = nil, textColor: UIColor? = nil, font: UIFont? = nil, attributedText: NSAttributedString? = nil, image: UIImage? = nil, contentEdgeInsets: UIEdgeInsets? = nil, imageSize: CGSize? = nil, imageDirection: DTB.FourDirection? = nil, imageOffset: CGVector? = nil) {
            self.title = title
            self.textColor = textColor
            self.font = font
            self.attributedText = attributedText
            self.image = image
            self.contentEdgeInsets = contentEdgeInsets
            self.imageSize = imageSize
            self.imageDirection = imageDirection
            self.imageOffset = imageOffset
        }
        
        public init?(dict: [String: Any]?) {
            guard let dict = dict else { return nil }
            
            // 标题
            self.title = dict["title"] as? String
            
            // 字体
            self.font = .dtb.create(dict["font"])
            
            // 文字颜色
            self.textColor = .dtb.create(dict["textColor"])
            
            // 图片
            self.image = .dtb.create(dict["image"])
            
            // 内边距
            self.contentEdgeInsets = {
                if let insetsDict = dict["contentEdgeInsets"] as? [String: CGFloat] {
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
            
            // 属性字符串一般不在 JSON 中解析，置 nil
            self.attributedText = nil
        }
        
    }
    
}
