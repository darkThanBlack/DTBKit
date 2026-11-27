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

extension DTB {
    
    public struct ButtonStyle {
        
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
        
        
        
    }
    
}
